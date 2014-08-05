//
//  Region+Create.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "Region+Create.h"
#import "FlickrFetcher.h"

@implementation Region (Create)

+ (Region *)regionWithPlaceID:(NSString *)placeId andPhotografer:(Photografer *)photografer inManagedObjectContext:(NSManagedObjectContext *) context {
    Region *region = nil;
    
    if ([placeId length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
        request.predicate = [NSPredicate predicateWithFormat:@"placeId = %@",placeId];
        NSError *error;
        NSArray *mathces = [context executeFetchRequest:request error:&error];
        
        if (!mathces || error || ([mathces count] > 1)) {
            ///
        } else if (![mathces count]) {
            region = [NSEntityDescription insertNewObjectForEntityForName:@"Region"
                                                   inManagedObjectContext:context];
            region.placeId = placeId;
            region.photoCount = @1;
            [region addPhotografersObject:photografer];
            region.photograferCount = @1;
            
        } else {
            region = [mathces lastObject];
            region.photoCount = @([region.photoCount intValue] + 1);
            if (![region.photografers member:photografer]) {
                [region addPhotografersObject:photografer];
                region.photograferCount = @([region.photograferCount intValue] + 1);
            }
        }
        

        
    }
    
    
    return region;
}

+ (Region *)regionWithPlaceID:(NSString *)placeId andPhotografer:(Photografer *)photografer inManagedObjectContext:(NSManagedObjectContext *) context withExistingRegions:(NSMutableArray *)existingRegions {
    Region *region = nil;
    if ([placeId length]) {
        NSArray *matches = [existingRegions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"placeId = %@",placeId]];
        if (!matches || ([matches count] > 1)) {
            // handle error
        } else if (![matches count]) {
            region = [NSEntityDescription insertNewObjectForEntityForName:@"Region"
                                                   inManagedObjectContext:context];
            region.placeId = placeId;
            region.photoCount = @1;
            [region addPhotografersObject:photografer];
            region.photograferCount = @1;
            [existingRegions addObject:region];
        } else {
            region = [matches lastObject];
            region.photoCount = @([region.photoCount intValue] + 1);
            if (![region.photografers member:photografer]) {
                [region addPhotografersObject:photografer];
                region.photograferCount = @([region.photograferCount intValue] + 1);
            }

        }
    }
    
    return region;
}

+ (void)loadRegionNamesFromFlickrIntoManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = [NSPredicate predicateWithFormat:@"name.length = %@", nil];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        // nothing to do ...
    } else {
        for (Region * match in matches) {
            NSURL *url = [FlickrFetcher URLforInformationAboutPlace:match.placeId];
            //dispatch_queue_t regionInfoQ = dispatch_queue_create("RegionInfo", NULL);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *jsonResult = [NSData dataWithContentsOfURL:url];
                NSDictionary *propertyList = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                             options:0
                                                                               error:NULL];
                NSString *name =[FlickrFetcher extractRegionNameFromPlaceInformation:propertyList];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    Region *region = nil;
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
                    request.predicate = [NSPredicate predicateWithFormat:@"placeId = %@", match.placeId];
                    
                    NSError *error;
                    NSArray *matches = [context executeFetchRequest:request error:&error];
                    if (!matches || ([matches count] != 1)) {
                        // handle error
                    } else {
                        region = [matches lastObject];
                        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
                        matches = [context executeFetchRequest:request error:&error];
                        
                        if (!matches) {
                            // handle error
                        } else if (![matches count]) {
                            region.name = name;
                        } else {
                            region.name = name;
                            for (Region *match in matches) {
                                region.photos = [region.photos setByAddingObjectsFromSet:match.photos];
                                region.photoCount = @([region.photos count]);
                                region.photografers = [region.photografers setByAddingObjectsFromSet:match.photografers];
                                region.photograferCount = @([region.photografers count]);
                                [context deleteObject:match];
                            }
                        }
                        [context save:NULL];
                    }

                });
                
            });

        }
        
    }
    
}

@end
