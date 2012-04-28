//
//  AppDelegate.h
//  gpsswimjam
//
//  Created by wearetitans on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GradientButton.h"
#import "MBProgressHUD.h"
#import "Swim.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSUserDefaults *defaults;
    
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSString *persistentStorePath;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIWindow *window;

@end
