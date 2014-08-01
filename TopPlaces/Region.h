//
//  Region.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Photografer;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * photoCount;
@property (nonatomic, retain) NSNumber * photograferCount;
@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSSet *photografers;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addPhotografersObject:(Photografer *)value;
- (void)removePhotografersObject:(Photografer *)value;
- (void)addPhotografers:(NSSet *)values;
- (void)removePhotografers:(NSSet *)values;

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
