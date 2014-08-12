//
//  LastRegion+ADD.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 04/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "LastRegion+ADD.h"
#import "Photo.h"

#define MAX_PHOTO_VIEW 20

@implementation LastRegion (ADD)

+ (LastRegion *)recentViewRegion:(Photo *)photo {
    LastRegion *last = nil;
    NSManagedObjectContext *context = photo.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LastRegion"];
    request.predicate = [NSPredicate predicateWithFormat:@"photo = %@",photo];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1) || error) {
        //error
    } else if (![matches count]) {
        last = [NSEntityDescription insertNewObjectForEntityForName:@"LastRegion"
                                             inManagedObjectContext:context ];
        last.lastView = [NSDate date];
        last.photo = photo;
        request.predicate = nil;
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastView"
                                                                ascending:NO
                                                                 selector:@selector(compare:)]];
        matches = [context executeFetchRequest:request error:&error];
        
        if ([matches count] > MAX_PHOTO_VIEW) {
            [context deleteObject:[matches lastObject]];
        }
    } else {
        last = [matches lastObject];
        last.lastView = [NSDate date];
    }
    [context save:&error];
    return last;
}


@end
