//
//  RegionTableViewController.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "RegionTableViewController.h"
#import "Region.h"
#import "Notification.h"
#import "PhotosFromRegionTVC.h"
#import "RefreshNotification.h"
#import "CoreDataStack.h"
#import "CoreDataManager.h"

@interface RegionTableViewController ()

@end

@implementation RegionTableViewController

#pragma mark - Initialization

- (void)awakeFromNib {
    
    [[NSNotificationCenter defaultCenter] addObserverForName:DatabaseNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.context = note.userInfo[DatabaseContext];
                                                      
                                                  }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishRefresh) name:STOP_REFRESH object:nil];
}

- (IBAction)refresh {
    [[NSNotificationCenter defaultCenter] postNotificationName:START_REFRESH object:self];
}

- (void)finishRefresh {
    [self.refreshControl endRefreshing];
}

#pragma mark - Proprieties

- (void)setContext:(NSManagedObjectContext *)context {
    _context = context;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = [NSPredicate predicateWithFormat:@"name.length > 0"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"photograferCount"
                                                              ascending:NO
                                 ],[NSSortDescriptor
                                    sortDescriptorWithKey:@"name"
                                    ascending:YES
                                    selector:@selector(localizedCaseInsensitiveCompare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:_context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.tableView reloadData];
}

#pragma mark - TableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Region Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = region.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@" %@ photografer and %@ photos",region.photograferCount,region.photoCount];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowPhotos"]) {
        if ([segue.destinationViewController isKindOfClass:[PhotosFromRegionTVC class]]) {
            PhotosFromRegionTVC *pvc = (PhotosFromRegionTVC *)segue.destinationViewController;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
            pvc.title = region.name;
            pvc.region = region;
        }
    }


}


@end
