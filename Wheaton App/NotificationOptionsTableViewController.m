//
//  NotificationOptionsTableViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/17/13.
//
//

#import "NotificationOptionsTableViewController.h"
#import "MasterTabViewController.h"

@interface NotificationOptionsTableViewController ()

@end

@implementation NotificationOptionsTableViewController

@synthesize notificationOptions;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    notificationOptions = [[NSMutableArray alloc] init];
    id token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@?device=%@",c_PushOptions, token];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    
    NSLog(@"%@", url);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: url]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData
{  
    if (responseData == nil) {
        return;
    }
    
    // parse out the json data
    NSError *error;
    NSMutableDictionary *mutableCategories = [[NSMutableDictionary alloc] init];
    for(NSDictionary *categories in [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error]) {
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
    NSError *error;
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:notificationOptions options:kNilOptions error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:c_PushOptions]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];

    NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding]);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void) toggledSwitch:(id)sender {
    UISwitch *toggleSwitch = (UISwitch *)sender;
    [[[[notificationOptions objectAtIndex:0] objectForKey:@"toggles"] objectAtIndex:toggleSwitch.tag]
     setObject:[NSNumber numberWithBool:toggleSwitch.isOn]
     forKey:@"boolean"];
    [self postToServer];
}

@end
