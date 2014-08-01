//
//  PhotosFromRegionTVC.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "PhotosFromRegionTVC.h"

@interface PhotosFromRegionTVC ()

@end

@implementation PhotosFromRegionTVC

#pragma mark - Proprieties

- (void)setRegion:(Region *)region {
    _region = region;
    self.title = region.name;
    [self fetchResults];
}

- (void)fetchResults {
    NSManagedObjectContext *context = self.region.managedObjectContext;
    if (context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"region = %@",self.region];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                  ascending:YES
                                                                   selector:@selector(localizedStandardCompare:)]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:context
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}



#pragma mark - Navigation

/// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"ShowImage"]) {
        if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
            ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
            [self prepareImageViewController:ivc
                                forIndexPath:indexPath];
            
        }
    }
    
}



@end
