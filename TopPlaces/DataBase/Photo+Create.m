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

 #define FLICKR_PLACE_PLACE_ID @"place.place_id"

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
        photo.thumbnailURl = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];

        NSString *photograferName =[photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
        
        photo.whoTook = [Photografer phograferWithName:photograferName
                                inManagedObjectContext:context];
       
        photo.region = [Region regionWithPlaceID:[photoDictionary valueForKeyPath:FLICKR_PHOTO_PLACE_ID]
                                  andPhotografer:photo.whoTook
                          inManagedObjectContext:context];
          }
    
    
    
    return photo;
}

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *)context
     withExistingPhotographers:(NSMutableArray *)existingPhotographers
           withExistingRegions:(NSMutableArray *)existingRegions {
    
    Photo *photo = nil;
    NSString *unique = photoDictionary[FLICKR_PHOTO_ID];

    photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                          inManagedObjectContext:context];
    photo.unique = unique;
    photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
    photo.despription = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
    photo.thumbnailURl = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
    
    NSString *photograferName =[photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
    photo.whoTook = [Photografer phograferWithName:photograferName
                            inManagedObjectContext:context
                     withExistingPhotographers:existingPhotographers];
    
    photo.region = [Region regionWithPlaceID:[photoDictionary valueForKeyPath:FLICKR_PHOTO_PLACE_ID]
                              andPhotografer:photo.whoTook
                      inManagedObjectContext:context
                         withExistingRegions:existingRegions];

    photo.createDate = [NSDate date];
    return photo;
}


+ (void)loadPhotosFromFlickrArray:(NSArray *)photos inManagedObjectContext:(NSManagedObjectContext *)context {
   /*     */
    NSMutableArray *newPhotos = [[NSMutableArray alloc] init];
    NSMutableArray *existingPhotographers = [[NSMutableArray alloc] init];
    NSMutableArray *existingRegions = [[NSMutableArray alloc] init];
    if ([photos count]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        NSArray *ids = [photos valueForKeyPath:FLICKR_PHOTO_ID];
        request.predicate = [NSPredicate predicateWithFormat:@"unique IN %@",ids];
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        if (!matches || ![matches count]) {
            // nothing to do ...
        } else {
            NSArray *existingPhotos = [matches valueForKeyPath:@"unique"];
            for (NSDictionary *photo in photos) {
                if (![existingPhotos containsObject:[photo valueForKeyPath:FLICKR_PHOTO_ID]]) {
                    [newPhotos addObject:photo];
                }
            }
            photos = newPhotos;
        }
        request = [NSFetchRequest fetchRequestWithEntityName:@"Photografer"];
        request.predicate = [NSPredicate predicateWithFormat:@"name IN %@", [photos valueForKeyPath:FLICKR_PHOTO_OWNER]];
        existingPhotographers = [[context executeFetchRequest:request error:&error] mutableCopy];
        
        request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
        NSArray *placeIDS = [photos valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", FLICKR_PHOTO_PLACE_ID]];
        request.predicate = [NSPredicate predicateWithFormat:@"placeId IN %@",placeIDS];
                             
        existingRegions = [[context executeFetchRequest:request error:&error] mutableCopy];
        
    }
    for (NSDictionary *photo in photos ) {
        [self photoWithFlickrInfo:photo
           inManagedObjectContext:context
        withExistingPhotographers:existingPhotographers
              withExistingRegions:existingRegions];
    }

    
    [Region loadRegionNamesFromFlickrIntoManagedObjectContext:context];
    [[NSNotificationCenter defaultCenter] postNotificationName:STOP_REFRESH
                                                        object:self];
    

}

#define TIMETODELETE (7*24*60*60)

+ (void)deleteOldPhotos:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"createDate < %@",[NSDate dateWithTimeIntervalSinceNow:-TIMETODELETE]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if ([matches count]) {
        for (Photo *photo in matches) {
            [photo remove];
        }
        [context save:NULL];
    }
}

- (void)remove {
    if ([self.whoTook.photos count] == 1) {
        [self.managedObjectContext deleteObject:self.whoTook];
    }
    if ([self.region.photos count] == 1) {
        [self.managedObjectContext deleteObject:self.region];
    } else {
        self.region.photograferCount = @([self.region.photografers count]);
        self.region.photoCount = @([self.region.photos count] - 1);
    }
    if (self.recent) {
        [self.managedObjectContext deleteObject:self.recent];
    }
    [self.managedObjectContext deleteObject:self];
}

@end
