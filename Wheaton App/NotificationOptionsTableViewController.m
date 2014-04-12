//
//  NotificationOptionsTableViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/17/13.
//
//

#import "NotificationOptionsTableViewController.h"

@interface NotificationOptionsTableViewController ()

@end

@implementation NotificationOptionsTableViewController {
    AFHTTPRequestOperationManager *manager;
}

@synthesize notificationOptions;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    notificationOptions = [[NSMutableArray alloc] init];
    id deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"token": deviceToken};
    [manager GET:c_PushOptions parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *topicResults = responseObject;
        NSMutableDictionary *mutableCategories = [[NSMutableDictionary alloc] init];
        for(NSDictionary *categories in topicResults) {
            NSMutableArray *mutableToggles = [[NSMutableArray alloc] init];
            for(NSDictionary *toggle in [categories objectForKey:@"toggles"]) {
                NSMutableDictionary *mutableToggle = [[NSMutableDictionary alloc] init];
                [mutableToggle setObject:[toggle objectForKey:@"boolean"] forKey:@"boolean"];
                [mutableToggle setObject:[toggle objectForKey:@"value"] forKey:@"value"];
                [mutableToggle setObject:[toggle objectForKey:@"name"] forKey:@"name"];
                [mutableToggles addObject:mutableToggle];
            }
            [mutableCategories setObject:mutableToggles forKey:@"toggles"];
            [mutableCategories setObject:[categories objectForKey:@"name"] forKey:@"name"];
            [notificationOptions addObject:mutableCategories];
        }
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
    return [notificationOptions count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[notificationOptions objectAtIndex:section] objectForKey:@"toggles"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[notificationOptions objectAtIndex:section] objectForKey:@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *row = [[[notificationOptions objectAtIndex:indexPath.section] objectForKey:@"toggles"] objectAtIndex:indexPath.row];
    
    UISwitch *toggleSwitch = [[UISwitch alloc] init];
    [toggleSwitch setOn:[[row objectForKey:@"boolean"] boolValue]];
    [toggleSwitch addTarget:self action:@selector(toggledSwitch:) forControlEvents:UIControlEventValueChanged];
    [toggleSwitch setTag:indexPath.row];
    cell.accessoryView = [[UIView alloc] initWithFrame:toggleSwitch.frame];
    [cell.accessoryView addSubview:toggleSwitch];
    
    cell.textLabel.text = [row objectForKey:@"name"];
    
    return cell;
}

- (void)postToServer {
    
    NSString *deviceToken = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    
    NSDictionary *parameters = @{@"token": deviceToken, @"toggles":notificationOptions };
    
    //[[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:c_PushOptions parameters:parameters];
    
    
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:c_PushOptions parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) toggledSwitch:(id)sender {
    UISwitch *toggleSwitch = (UISwitch *)sender;
    [[[[notificationOptions objectAtIndex:0] objectForKey:@"toggles"] objectAtIndex:toggleSwitch.tag]
     setObject:[NSNumber numberWithBool:toggleSwitch.isOn]
     forKey:@"boolean"];
    [self postToServer];
}

@end
