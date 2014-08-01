//
//  MyFlickr.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 28/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "FlickrFetcher.h"

@interface MyFlickr : FlickrFetcher

+ (NSString *)getCountry:(NSDictionary *)place;
+ (NSDictionary *)placesByContries:(NSArray *)places;
+ (NSArray *)countrieOfPlaces:(NSDictionary *)placesByContries;
+ (NSArray *)sortPlaces:(NSArray *)places;

@end
