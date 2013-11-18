//
//  NotificationsViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/16/13.
//
//

#import "NotificationsViewController.h"
#import "PushNotification.h"

@implementation NotificationsViewController

@synthesize pushNotifications;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    pushNotifications = [[NSMutableArray alloc] init];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [pushNotifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = ((PushNotification *)[pushNotifications objectAtIndex:indexPath.row]).body;
    // Configure the cell...
    
    return cell;
}
- (void)addPushNotification:(NSDictionary *)notification {
    NSLog(@"Added notification");
    PushNotification *pushNotification = [[PushNotification alloc] init];
    notification = [notification objectForKey:@"aps"];
    NSLog(@"%@", notification);
    if ([notification objectForKey:@"alert"]) {
        id theAlert = [notification objectForKey:@"alert"];
        
        if ([theAlert isKindOfClass:[NSString class]]) {
            pushNotification.body = (NSString *)theAlert;
        } else if ([theAlert isKindOfClass:[NSDictionary class]] && [(NSDictionary *)theAlert objectForKey:@"body"]) {
            pushNotification.body = [(NSDictionary *)theAlert objectForKey:@"body"];
        }
    }
    
    [pushNotifications addObject:pushNotification];
    NSLog(@"%d", [pushNotifications count]);
    [self.tableView reloadData];
    
}

@end
