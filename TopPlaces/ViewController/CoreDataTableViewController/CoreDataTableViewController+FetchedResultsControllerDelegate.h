//
//  CoreDataTableViewController+FetchedResultsControllerDelegate.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 12/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface CoreDataTableViewController (FetchedResultsControllerDelegate)

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type;

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath;

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;




@end
