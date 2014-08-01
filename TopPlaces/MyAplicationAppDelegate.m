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

#define FLICKR_FETCH @"Flickr Just Uploaded Fetch"
@interface MyAplicationAppDelegate()<NSURLSessionDataDelegate>

@property (nonatomic, strong)NSURLSession *flickrDownloadSession;

@end

@implementation MyAplicationAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURL *url = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]firstObject];
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
    
    return YES;
}

- (void)documentIsReady {
    if (self.document.documentState == UIDocumentStateNormal) {
        // start using document
        self.context = self.document.managedObjectContext;
        [self startFlickrFetch];
    }
}

- (void)startFlickrFetch {
    [self.flickrDownloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if (![downloadTasks count]) {
            NSURLSessionDownloadTask *task = [self.flickrDownloadSession downloadTaskWithURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]];
            [task resume];
        } else {
            for (NSURLSessionDownloadTask *task in downloadTasks) {
                [task resume];
            }
        }
    }];
}

- (NSURLSession *)flickrDownloadSession {
    if (!_flickrDownloadSession) {
        static dispatch_once_t onceToken; // dispatch_once ensures that the block will only ever get executed once per application launch
        dispatch_once(&onceToken, ^{
            // notice the configuration here is "backgroundSessionConfiguration:"
            // that means that we will (eventually) get the results even if we are not the foreground application
            // even if our application crashed, it would get relaunched (eventually) to handle this URL's results!
            NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration backgroundSessionConfiguration:FLICKR_FETCH];
            _flickrDownloadSession = [NSURLSession sessionWithConfiguration:urlSessionConfig
                                                                   delegate:self    // we MUST have a delegate for background configurations
                                                              delegateQueue:nil];   // nil means "a random, non-main-queue queue"
        });
    }
    return _flickrDownloadSession;

}

#pragma mark - NSURLSessionDownloadDelegate

// required by the protocol
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)localFile
{
    // we shouldn't assume we're the only downloading going on ...
    if ([downloadTask.taskDescription isEqualToString:FLICKR_FETCH]) {
        // ... but if this is the Flickr fetching, then process the returned data
        [self loadFlickrPhotosFromLocalURL:localFile
                               intoContext:self.context
                       andThenExecuteBlock:^{
                           //[self flickrDownloadTasksMightBeComplete];
                       }
         ];
    }
}

- (void)loadFlickrPhotosFromLocalURL:(NSURL *)localFile
                         intoContext:(NSManagedObjectContext *)context
                 andThenExecuteBlock:(void(^)())whenDone
{
    if (context) {
        NSArray *photos = [self flickrPhotosAtURL:localFile];
        [context performBlock:^{
            [Photo loadPhotosFromFlickrArray:photos inManagedObjectContext:context];
            [context save:NULL]; // NOT NECESSARY if this is a UIManagedDocument's context
            if (whenDone) whenDone();
        }];
    } else {
        if (whenDone) whenDone();
    }
}

- (NSArray *)flickrPhotosAtURL:(NSURL *)url
{
    NSDictionary *flickrPropertyList;
    NSData *flickrJSONData = [NSData dataWithContentsOfURL:url];  // will block if url is not local!
    if (flickrJSONData) {
        flickrPropertyList = [NSJSONSerialization JSONObjectWithData:flickrJSONData
                                                             options:0
                                                               error:NULL];
    }
    return [flickrPropertyList valueForKeyPath:FLICKR_RESULTS_PHOTOS];
}

/*- (void)flickrDownloadTasksMightBeComplete
{
    if (self.flickrDownloadBackgroundURLSessionCompletionHandler) {
        [self.flickrDownloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
            // we're doing this check for other downloads just to be theoretically "correct"
            //  but we don't actually need it (since we only ever fire off one download task at a time)
            // in addition, note that getTasksWithCompletionHandler: is ASYNCHRONOUS
            //  so we must check again when the block executes if the handler is still not nil
            //  (another thread might have sent it already in a multiple-tasks-at-once implementation)
            if (![downloadTasks count]) {  // any more Flickr downloads left?
                // nope, then invoke flickrDownloadBackgroundURLSessionCompletionHandler (if it's still not nil)
                void (^completionHandler)() = self.flickrDownloadBackgroundURLSessionCompletionHandler;
                self.flickrDownloadBackgroundURLSessionCompletionHandler = nil;
                if (completionHandler) {
                    completionHandler();
                }
            } // else other downloads going, so let them call this method when they finish
        }];
    }
}
*/

// required by the protocol
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // we don't support resuming an interrupted download task
}

// required by the protocol
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // we don't report the progress of a download in our UI, but this is a cool method to do that with
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
