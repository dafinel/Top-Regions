//
//  PhotoForPlaceTableViewController.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 28/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "PhotoForPlaceTableViewController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface PhotoForPlaceTableViewController ()
@end

@implementation PhotoForPlaceTableViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPhoto];
}


static int const maxresults = 50;

- (IBAction)fetchPhoto {
    [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:[self.place valueForKey:FLICKR_PLACE_ID] maxResults:maxresults];
    dispatch_queue_t photoForPlaceQ = dispatch_queue_create("PhotoForPlace", NULL);
    dispatch_async(photoForPlaceQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyList = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                     options:0
                                                                       error:NULL];
        NSArray *photos = [propertyList valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
}

#pragma mark -TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    if ([detail isKindOfClass:[ImageViewController class]]) {
        [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
    }

}

#pragma mark - Navigation

- (void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(NSDictionary *)photo
{
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    if(![[photo valueForKeyPath:FLICKR_PHOTO_TITLE] isEqualToString:@""]) {
        ivc.title =  [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    } else if (![[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] isEqualToString:@""]) {
        ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    } else {
        ivc.title = @"Unknown";
    }
    [self addToNSUserDefault:[FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge]
                    forPhoto:photo];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"ShowImage"]) {
        if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
            ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
            [self prepareImageViewController:ivc
                              toDisplayPhoto:self.photos[indexPath.row]];
          //  [self addToNSUserDefault:[FlickrFetcher URLforPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge]
             //               forPhoto:self.photos[indexPath.row]];
        }
    }
}

#pragma mark - ADD To NSUserDefault

- (void)addToNSUserDefault:(NSURL *)url forPhoto:(NSDictionary *)photo {
    NSMutableDictionary *rezults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"test2"] mutableCopy];
    if (!rezults) {
        rezults = [[NSMutableDictionary alloc] init];
    }
    NSString *urlString = [url absoluteString];
    NSDictionary *dic = @{@"url":urlString,
                          @"photo":photo};
    NSString *keyToUpdateView;
    BOOL ok = NO;
    for (int i= 1; i <= [[rezults allKeys] count]; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        if ([rezults[key][@"url"] isEqualToString:urlString]) {
            ok = YES;
            keyToUpdateView = key;
        }
    }
    if (!ok) {
        if ([[rezults allKeys] count] == 20) {
            for( int i = 1; i < 20; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                NSString *key1 = [NSString stringWithFormat:@"%d",i+1];
                [rezults setObject:rezults[key1] forKey:key];
            }
            
            [rezults setObject:dic forKey:@"20"];
        } else {
            NSString *key = [NSString stringWithFormat:@"%d",[[rezults allKeys] count]+1];
            [rezults setObject:dic forKey:key];
        }
    } else {
         NSString *keyOfLastView = [NSString stringWithFormat:@"%d",[[rezults allKeys] count]];
        [rezults setObject:[rezults objectForKey:keyOfLastView] forKey:keyToUpdateView];
        [rezults setObject:urlString forKey:keyOfLastView];
    }
    [[NSUserDefaults standardUserDefaults] setObject:rezults forKey:@"test2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  
}


@end
