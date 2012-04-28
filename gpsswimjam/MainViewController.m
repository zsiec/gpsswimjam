//
//  ViewController.m
//  gpsswimjam
//
//  Created by wearetitans on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "SummaryViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize tableView;



- (void)viewDidLoad
{
    [super viewDidLoad];
    id appDelegate = [(id)[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    [self fetch];

}

- (void)fetch {
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    [self.tableView reloadData];
}


- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Swim" inManagedObjectContext:managedObjectContext]];
        NSArray *sortDescriptors = nil;
        sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO  ] ];
        [fetchRequest setSortDescriptors:sortDescriptors];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }    
    return fetchedResultsController;
}  


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    Swim *swim = [fetchedResultsController objectAtIndexPath:indexPath];
    nextSwim = swim;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	return UITableViewCellEditingStyleDelete; 
} 



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *eventToDelete = [managedObjectContext objectWithID:[[fetchedResultsController objectAtIndexPath:indexPath] objectID]];
    [managedObjectContext deleteObject:eventToDelete];
    [managedObjectContext save:NULL];
    [self fetch];
    
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self tableView] reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self fetchedResultsController] fetchedObjects] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @""; //@"Top";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return @""; //@"Bottom";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"swimCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *durationLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *distanceLabel = (UILabel *)[cell.contentView viewWithTag:2];
    
    Swim *swim = [fetchedResultsController objectAtIndexPath:indexPath];
    
    double swimTime = [[swim swimDuration] doubleValue];
    
    int minutes = swimTime / 60;
    int seconds = swimTime - (60 * minutes);
    int tenths = (swimTime - (double)(60 * minutes + seconds)) * 10;
    
    
    NSString *formattedTime = [NSString stringWithFormat: @"%d:%02d.%01d", minutes, seconds, tenths];
    
    durationLabel.text = formattedTime;
    distanceLabel.text = [NSString stringWithFormat:@"%i", [[swim swimDistance] intValue] ];
    
    return cell;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"mainToSummaryViewSeugue"]){
        NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
        SummaryViewController *vc = [segue destinationViewController];
        [vc initializeSwim:[fetchedResultsController objectAtIndexPath:selectedIndex]];
    }
    
}




@end
