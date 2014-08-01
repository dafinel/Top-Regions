//
//  Photo.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LastRegion, Photografer, Region;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * despription;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * thumbnailURl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) LastRegion *recent;
@property (nonatomic, retain) Region *region;
@property (nonatomic, retain) Photografer *whoTook;

@end
