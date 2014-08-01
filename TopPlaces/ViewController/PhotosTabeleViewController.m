//
//  PhotosTabeleViewController.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "PhotosTabeleViewController.h"
#import "Photo+Create.h"
#import "ImageViewController.h"

@interface PhotosTabeleViewController ()

@end

@implementation PhotosTabeleViewController

#pragma mark -TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    if ([detail isKindOfClass:[ImageViewController class]]) {
        [self prepareImageViewController:detail forIndexPath:indexPath];
    }
    
}


#pragma mark - TableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo Cell"
                                                            forIndexPath:indexPath];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.despription;
    return cell;
}

#pragma mark - Navigation

- (void)prepareImageViewController:(ImageViewController *)ivc forIndexPath:(NSIndexPath *)indexPath {
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ivc.title = photo.title;
    ivc.imageURL = [NSURL URLWithString:photo.imageURL];
}



@end
