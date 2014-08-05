//
//  Photografer+Create.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "Photografer.h"

@interface Photografer (Create)

+ (Photografer *)phograferWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Photografer *)phograferWithName:(NSString *)name
            inManagedObjectContext:(NSManagedObjectContext *)context
         withExistingPhotographers:(NSMutableArray *)existingPhotographers;

@end
