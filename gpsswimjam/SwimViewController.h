//
//  SwimViewController.h
//  gpsswimjam
//
//  Created by wearetitans on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SwimViewController : UIViewController <CLLocationManagerDelegate>
{
    
    MBProgressHUD *HUD;
    
    CLLocationManager *locationManager;
    
    NSTimer *swimTimer;
    
    NSDate *startTime;
    
    BOOL started;
    BOOL finished;
    BOOL startRecording;
    
    NSManagedObjectContext *managedObjectContext;
    
    NSTimer *countdownTimer;
    NSDate *countdownStartTime;
    
    Swim *swim;
    
    double ydDistance;
    double distance;
}
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet GradientButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel;
@property (weak, nonatomic) IBOutlet UILabel *yardsLabel;

@end
