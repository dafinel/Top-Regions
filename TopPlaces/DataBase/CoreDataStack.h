//
//  CoreDataStack.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 12/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataStack : NSObject

@property (nonatomic, strong)NSManagedObjectContext *context;

- (NSManagedObjectContext *)getBackgroundContext;
- (void)getUIManagedDocument;

@end
