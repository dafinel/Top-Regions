//
//  LastRegion.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface LastRegion : NSManagedObject

@property (nonatomic, retain) NSDate * lastView;
@property (nonatomic, retain) Photo *photo;

@end
