//
//  MyFlickr.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 28/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "MyFlickr.h"

@implementation MyFlickr

+ (NSString *)getCountry:(NSDictionary *)place{
    return [[[place valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
}

+ (NSDictionary *)placesByContries:(NSArray *)places {
    NSMutableDictionary *placesbyCountries = [NSMutableDictionary dictionary];
    for (NSDictionary *place in places) {
        NSString *country = [MyFlickr getCountry:place];
        NSMutableArray *placesOfCountry = placesbyCountries[country];
        if (!placesOfCountry) {
            placesOfCountry = [NSMutableArray array];
            placesbyCountries[country] = placesOfCountry;
        }
        [placesOfCountry addObject:place];
    }
    
    return placesbyCountries;
}

+ (NSArray *)countrieOfPlaces:(NSDictionary *)placesByContries {
    NSArray *countries = [placesByContries allKeys];
    countries = [countries sortedArrayUsingSelector:@selector(compare:)];
    return countries;
}

+ (NSArray *)sortPlaces:(NSArray *)places {
    return [places sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *s1 = [obj1 valueForKeyPath:FLICKR_PLACE_NAME];
        NSString *s2 = [obj2 valueForKeyPath:FLICKR_PLACE_NAME];
        return [s1 compare:s2];
        
    }];
}

@end
