//
//  Photo+Create.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "Photo.h"

@interface Photo (Create)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photo inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)loadPhotosFromFlickrArray:(NSArray *)photos inManagedObjectContext:(NSManagedObjectContext *)context;

@end
