//
//  CoreDataManager.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 12/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataStack.h"

@interface CoreDataManager : NSObject

@property (nonatomic, strong)CoreDataStack *coreData;

- (instancetype)initWithCoreDataStack:(CoreDataStack *)coreData;
- (void)startFlickrFetch;
- (void)startMonitoringForFlickrFetch;

@end
