//
//  ListViewController.m
//  ar-project
//
//  Created by Leonel Galan on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    nearby = [[NSMutableArray alloc] initWithCapacity:[[appDelegate.data allValues] count]];
    rest = [[NSMutableArray alloc] initWithCapacity:[[appDelegate.data allValues] count]];

    for (NSDictionary *dictionary in [appDelegate.data allValues]) {
        Picture *picture = [[Picture alloc] initWithDictionary:dictionary];
        
        NSLog(@"User: %.6f, %.6f", appDelegate.userLocation.coordinate.latitude, appDelegate.userLocation.coordinate.longitude);
        NSLog(@"Picture: %.6f, %.6f", picture.location.coordinate.latitude, picture.location.coordinate.longitude);
        NSLog(@"Distance: %.6f", [appDelegate.userLocation distanceFromLocation:picture.location]);
        
        if (appDelegate.userLocation) {
            if ([appDelegate.userLocation distanceFromLocation:picture.location] < 1000.0) {
                [nearby addObject:picture];
            } else {
                [rest addObject:picture];
            }
        } else {
            [rest addObject:picture];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Nearby";
    } else {
        return @"Other";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return nearby.count;
    } else {
        return rest.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Picture *picture;
    if (indexPath.section == 0) {
        picture = [nearby objectAtIndex:indexPath.row];
    } else {
        picture = [rest objectAtIndex:indexPath.row];
    }
    
    [cell.textLabel setText:picture.title];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
