//
//  CoreDataStack.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 12/08/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "CoreDataStack.h"
#import <CoreData/CoreData.h>
#import "Notification.h"


@interface CoreDataStack()

@property (nonatomic, strong)UIManagedDocument *document;

@end


@implementation CoreDataStack

- (void)setContext:(NSManagedObjectContext *)context {
    _context = context;
    NSDictionary *userInfo = self.context ? @{DatabaseContext : self.context} : nil;
   [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseNotification object:self userInfo:userInfo];
}

- (void)getUIManagedDocument {
    
    NSURL *url = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"TopRegions.xcdatamodeld"];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            if (success) [self documentIsReady];
            if (!success) NSLog(@"couldn’t open document ");
        }]; } else {
            [self.document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
                   completionHandler:^(BOOL success) {
                       if (success) [self documentIsReady];
                       if (!success) NSLog(@"couldn’t create document ");
                   }];
        }
    
    
}

- (void)documentIsReady {
    if (self.document.documentState == UIDocumentStateNormal) {
        // start using document
        self.context = self.document.managedObjectContext;
    }
}

- (NSManagedObjectContext *)getBackgroundContext {
    
    NSManagedObjectContext *_backgroundManagedObjectContext;
    NSPersistentStoreCoordinator *coordinator = self.document.managedObjectContext.persistentStoreCoordinator;
    if (!coordinator) {
        // Error if we don't have a coordinator.
        return nil;
    }
    
    // Create the Background Managed Object Context
    _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_backgroundManagedObjectContext setPersistentStoreCoordinator:coordinator];
    [_backgroundManagedObjectContext setUndoManager:nil];
        
    // Notify the main queue of changes the background queue makes
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:_backgroundManagedObjectContext
                                                       queue:[NSOperationQueue mainQueue]
                                                       usingBlock:^(NSNotification *note) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self.context mergeChangesFromContextDidSaveNotification:note];
                                                           });
                                                       }];



    return _backgroundManagedObjectContext;
}

@end
