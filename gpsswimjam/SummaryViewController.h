//
//  SummaryViewController.h
//  gpsswimjam
//
//  Created by wearetitans on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SummaryViewController : UIViewController
{
    Swim *swim;
}
- (void)initializeSwim:(Swim *)sentSwim;
@property (weak, nonatomic) IBOutlet UILabel *timerlabel;
@property (weak, nonatomic) IBOutlet UILabel *distancelabel;

@end
