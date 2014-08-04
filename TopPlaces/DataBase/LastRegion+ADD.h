//
//  LastRegion+ADD.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 04/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "LastRegion.h"
#import "Region.h"

@interface LastRegion (ADD)

+ (LastRegion *)recentViewRegion:(Photo *)photo;

@end
