//
//  MyAplicationAppDelegate.m
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 28/07/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MyAplicationAppDelegate.h"
#import "FlickrFetcher.h"
#import "Photo+Create.h"
#import "Notification.h"
#import "Reachability.h"
#import "RefreshNotification.h"
#import "CoreDataStack.h"

@interface MyAplicationAppDelegate()<NSURLSessionDataDelegate>

//@property (copy, nonatomic) void (^flickrDownloadBackgroundURLSessionCompletionHandler)();

@end

@implementation MyAplicationAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
     [self.coreData getUIManagedDocument];
     self.manager = [[CoreDataManager alloc] initWithCoreDataStack:self.coreData];
     [self.manager startFlickrFetch];
     [self.manager startMonitoringForFlickrFetch];
    
    return YES;
}

- (CoreDataStack *)coreData {
    if (!_coreData) {
       _coreData = [[CoreDataStack alloc] init];
    }
    return _coreData;
}

#pragma mark -Background update

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (self.manager) {
      [self.manager startFlickrFetch];
    } else {
        completionHandler(UIBackgroundFetchResultNoData); // no app-switcher update if no database!
    }

}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    //self.flickrDownloadBackgroundURLSessionCompletionHandler = completionHandler;
}

@end
