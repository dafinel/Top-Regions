//
//  Photografer+Create.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 01/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "Photografer+Create.h"

@implementation Photografer (Create)

+ (Photografer *)phograferWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context {
    Photografer *photografer = nil;
    
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photografer"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
        NSError *error;
        NSArray *mathes = [context executeFetchRequest:request
                                                 error:&error];
        if (!mathes || ([mathes count] > 1)) {
            //error
        } else if (![mathes count]) {
            photografer = [NSEntityDescription insertNewObjectForEntityForName:@"Photografer"
                                                        inManagedObjectContext:context];
            photografer.name = name;
        } else {
            photografer = [mathes firstObject];
        }
        
    }
    
    
    return photografer;
}

@end
