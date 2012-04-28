//
//  SummaryViewController.m
//  gpsswimjam
//
//  Created by wearetitans on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SummaryViewController.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController
@synthesize timerlabel;
@synthesize distancelabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    distancelabel.text = [NSString stringWithFormat:@"%i", [[swim swimDistance] intValue] ];
    
    double swimTime = [[swim swimDuration] doubleValue];
    
    int minutes = swimTime / 60;
    int seconds = swimTime - (60 * minutes);
    int tenths = (swimTime - (double)(60 * minutes + seconds)) * 10;
    
    
    NSString *formattedTime = [NSString stringWithFormat: @"%d:%02d.%01d", minutes, seconds, tenths];
    
    timerlabel.text = formattedTime;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTimerlabel:nil];
    [self setDistancelabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)initializeSwim:(Swim *)sentSwim
{
    swim = sentSwim;
}

@end
