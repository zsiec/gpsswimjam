//
//  ViewController.h
//  gpsswimjam
//
//  Created by wearetitans on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *swimList;
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext  *managedObjectContext;
    NSEntityDescription *entityDesc;

    Swim *nextSwim;
    
    IBOutlet UITableView *tableView;
}


@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain, readonly) NSFetchedResultsController *fetchedResultsController;

-(void)fetch;

@end
