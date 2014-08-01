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
            region = [mathces firstObject];
            region.photoCount = @([region.photoCount intValue]+1);
            if (![region.photografers member:photografer]) {
                [region addPhotografersObject:photografer];
                region.photograferCount = @([region.photograferCount intValue]+1);
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
            __block Region *editableMatch = match;
            NSURL *url = [FlickrFetcher URLforInformationAboutPlace:match.placeId];
            //dispatch_queue_t regionInfoQ = dispatch_queue_create("RegionInfo", NULL);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *jsonResult = [NSData dataWithContentsOfURL:url];
                NSDictionary *propertyList = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                             options:0
                                                                               error:NULL];
                NSString *name =[FlickrFetcher extractRegionNameFromPlaceInformation:propertyList];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    editableMatch.name = name;
                });
            });

        }
        
    }
    for (Region * match in matches) {
        NSLog(@"%@",match.name);
    }
}

@end
