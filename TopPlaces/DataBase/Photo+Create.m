//
//  Photo+Create.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "Photo+Create.h"
#import "FlickrFetcher.h"
#import "Photografer+Create.h"
#import "Region+Create.h"

@implementation Photo (Create)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context {
    Photo *photo = nil;
    NSString *unique = photoDictionary[FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",unique];
    NSError *error;
    NSArray *mathces = [context executeFetchRequest:request error:&error];
    
    if (!mathces || error || ([mathces count] > 1)) {
        ///
    } else if ([mathces count]) {
        photo = [mathces firstObject];
    } else {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                              inManagedObjectContext:context];
        photo.unique = unique;
        photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.despription = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        NSString *photograferName =[photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
        
        photo.whoTook = [Photografer phograferWithName:photograferName
                                inManagedObjectContext:context];
        photo.region = [Region regionWithPlaceID:[photoDictionary valueForKeyPath:FLICKR_PHOTO_PLACE_ID]
                                  andPhotografer:photo.whoTook
                          inManagedObjectContext:context];
    }
    
    
    
    return photo;
}
+ (void)loadPhotosFromFlickrArray:(NSArray *)photos inManagedObjectContext:(NSManagedObjectContext *)context {
    for (NSDictionary *photo in photos) {
        [self photoWithFlickrInfo:photo inManagedObjectContext:context];
    }
    [Region loadRegionNamesFromFlickrIntoManagedObjectContext:context];
    

}


@end
