//
//  Region+Create.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "Region.h"

@interface Region (Create)

+ (Region *)regionWithPlaceID:(NSString *)placeId andPhotografer:(Photografer *)photografer inManagedObjectContext:(NSManagedObjectContext *) context;
+ (void)loadRegionNamesFromFlickrIntoManagedObjectContext:(NSManagedObjectContext *)context;
+ (Region *)regionWithPlaceID:(NSString *)placeId andPhotografer:(Photografer *)photografer inManagedObjectContext:(NSManagedObjectContext *) context withExistingRegions:(NSMutableArray *)existingRegions;

@end
