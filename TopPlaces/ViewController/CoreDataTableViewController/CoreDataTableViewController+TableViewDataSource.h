//
//  CoreDataTableViewController+TableViewDataSource.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 12/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface CoreDataTableViewController (TableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;


@end
