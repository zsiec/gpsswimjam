//
//  SwimViewController.m
//  gpsswimjam
//
//  Created by wearetitans on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SwimViewController.h"
#import "SummaryViewController.h"

@interface SwimViewController ()

@end

@implementation SwimViewController
@synthesize timerLabel;
@synthesize startStopButton;
@synthesize milesLabel;
@synthesize yardsLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Your Swim";
    
    started = NO;
    finished = NO;
    
    ydDistance = 0.0;
    distance = 0.0;
    
    startRecording = NO;
    
    [startStopButton useGreenConfirmStyle];
    
    id appDelegate = [(id)[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 2.0;
    
    if(managedObjectContext!=nil){
        swim = (Swim *)[NSEntityDescription insertNewObjectForEntityForName:@"Swim" inManagedObjectContext:managedObjectContext];
        [swim setCreatedAt:[NSDate date]];
    }

}

- (IBAction)startStopTimerAction:(id)sender {
    if(!started){
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = @"10";
        HUD.removeFromSuperViewOnHide = YES;
        HUD.dimBackground = YES;
        HUD.square = YES;
        HUD.labelFont = [UIFont fontWithName:@"System" size:40];
        
        [HUD hide:YES afterDelay:10];
        
        [self startTracking];
        startStopButton.enabled = NO;
        countdownStartTime = [NSDate date];
        countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownCounterUpdateMethod:) userInfo:nil repeats:YES];
    
    }
    else {
        [self stopEvent];
    }
}

- (void)countdownCounterUpdateMethod:(NSTimer*)theTimer {
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval elapsedTime = [currentDate timeIntervalSinceDate:countdownStartTime];
    NSTimeInterval difference = 10 - elapsedTime;
    
    if(difference > 0){
        HUD.labelText = [NSString stringWithFormat:@"%1.f", difference];
    }else{
        HUD.labelText = @"Go!";
    }
    
    if(difference <= 0){
        startStopButton.enabled = YES;
        startRecording = YES;
        [self startEvent];
        [theTimer invalidate];
        difference = 0;
    }

}

- (void)startTracking
{
    //start updating the user's location
    [locationManager startUpdatingLocation];
}

-(void)stopTracking
{
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}


- (void)timerUpdateMethod:(NSTimer*)theTimer {
    NSDate *currentDate = [NSDate date];
    NSTimeInterval elapsedTime = [currentDate timeIntervalSinceDate:startTime];
    
    int minutes = elapsedTime / 60;
    int seconds = elapsedTime - (60 * minutes);
    int tenths = (elapsedTime - (double)(60 * minutes + seconds)) * 10;
    
    NSString *formattedTime = [NSString stringWithFormat: @"%d:%02d.%01d", minutes, seconds, tenths];
    timerLabel.text = formattedTime;
}

- (void)startEvent{
    startTime = [NSDate date];
    swimTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerUpdateMethod:) userInfo:nil repeats:YES];
    started = YES;
    [startStopButton setBackgroundImage:[UIImage imageNamed:@"button_red.png"] forState:UIControlStateNormal];
    [startStopButton setTitleColor:[UIColor colorWithRed:100/255 green:100/255 blue:100/255 alpha:1.0] forState:UIControlStateNormal];
    [startStopButton setTitle:@"Stop Run" forState:UIControlStateNormal];

}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //make sure the horizontal accuracy is sane
    if(newLocation.horizontalAccuracy < 0) return;
    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 30.0) return;
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    
    if(startRecording){
        distance += ([newLocation distanceFromLocation:oldLocation] * 0.00062137119);
        ydDistance += ([newLocation distanceFromLocation:oldLocation] * 1.0936133);
        
        NSString *labelText = [formatter stringFromNumber:[NSNumber numberWithDouble:fabs(distance)]];
        yardsLabel.text = [NSString stringWithFormat:@"%i", (int)fabs(ydDistance)];
        
        //distanceLabel.text = [NSString stringWithFormat:@"%.1f", fabs(distance)];
        milesLabel.text = labelText;
    }
}


- (void)stopEvent{
    finished = YES;
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval elapsedTime = [currentDate timeIntervalSinceDate:startTime];
    
    
    [swim setSwimDuration:[NSNumber numberWithDouble:elapsedTime ] ];
    [swim setSwimDistance:[NSNumber numberWithDouble:ydDistance]];
    [managedObjectContext save:NULL];
    
    [self stopTimer];
    [self stopTracking];
    
    [self performSegueWithIdentifier:@"swimToSummarySegue" sender:NULL];
    
}

-(void) stopTimer{
    [swimTimer invalidate];
    swimTimer = nil; 
}


- (void)viewDidUnload
{
    [self setTimerLabel:nil];
    [self setStartStopButton:nil];
    [self setMilesLabel:nil];
    [self setYardsLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self stopTracking];
    [self stopTimer];
    SummaryViewController *vc = [segue destinationViewController];
    [vc initializeSwim:swim];
}

@end
