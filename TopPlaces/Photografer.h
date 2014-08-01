//
//  Photografer.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Region;

@interface Photografer : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *regions;
@end

@interface Photografer (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addRegionsObject:(Region *)value;
- (void)removeRegionsObject:(Region *)value;
- (void)addRegions:(NSSet *)values;
- (void)removeRegions:(NSSet *)values;

@end
