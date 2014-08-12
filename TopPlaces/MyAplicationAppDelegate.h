//
//  MyAplicationAppDelegate.h
//  TopPlaces
//
//  Created by Andrei-Daniel Anton on 28/07/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"
#import "CoreDataManager.h"

@interface MyAplicationAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CoreDataStack *coreData;
@property (nonatomic, strong) CoreDataManager *manager;

@end
