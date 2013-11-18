//
//  MoreTableViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import "MoreTableViewController.h"

@interface MoreTableViewController ()

@end

@implementation MoreTableViewController

@synthesize moreTable, moreHeaders;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSMutableDictionary *menuOption = [[NSMutableDictionary alloc] init];
    UIViewController *mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    [menuOption setValue:mVC forKey:@"controller"];
    [menuOption setValue:@"Meal Menu" forKey:@"name"];
    
    NSMutableDictionary *notificationOption = [[NSMutableDictionary alloc] init];
    UIViewController *nVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationOptions"];
    [notificationOption setValue:nVC forKey:@"controller"];
    [notificationOption setValue:@"Notification Toggles" forKey:@"name"];
    
    
    moreTable = [[NSMutableArray alloc] init];
    moreHeaders = [[NSMutableArray alloc] init];
    
    [moreTable addObject:menuOption];
    [moreTable addObject:notificationOption];
    [moreHeaders addObject:@"Options"];
    
    [self.tableView reloadData];
    
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [moreTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[moreTable objectAtIndex:indexPath.row] objectForKey:@"name"];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *selected = [[moreTable objectAtIndex:indexPath.row] objectForKey:@"controller"];
    selected.title = [[moreTable objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self.navigationController
     pushViewController:selected
     animated:YES];
}


/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
