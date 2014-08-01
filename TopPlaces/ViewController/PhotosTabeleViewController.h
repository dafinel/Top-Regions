//
//  PhotosTabeleViewController.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "ImageViewController.h"

@interface PhotosTabeleViewController : CoreDataTableViewController

- (void)prepareImageViewController:(ImageViewController *)ivc forIndexPath:(NSIndexPath *)indexPath;

@end
