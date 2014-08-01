//
//  LastPhotoTableViewController.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 29/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "LastPhotoTableViewController.h"
#import "ImageViewController.h"
#import "FlickrFetcher.h"

@interface LastPhotoTableViewController ()

@end

@implementation LastPhotoTableViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self lastPhotos];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self lastPhotos];
}

- (void)lastPhotos {
    NSMutableDictionary *rezults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"test2"] mutableCopy];
    NSMutableArray *photos = [NSMutableArray array];
    if (rezults) {
        for (int i = [[rezults allKeys] count]; i > 0; i--) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            [photos addObject:rezults[key][@"photo"]];
        }
    }
    self.photos = photos;

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
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{ // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"Last Photo"]) {
        if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
            ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
            ivc.imageURL = [FlickrFetcher URLforPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
            if(![[self.photos[indexPath.row] valueForKeyPath:FLICKR_PHOTO_TITLE] isEqualToString:@""]) {
                ivc.title =  [self.photos[indexPath.row] valueForKeyPath:FLICKR_PHOTO_TITLE];
            } else if (![[self.photos[indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] isEqualToString:@""]) {
                ivc.title = [self.photos[indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
            } else {
                ivc.title = @"Unknown";
            }
        }
    }
}


@end
