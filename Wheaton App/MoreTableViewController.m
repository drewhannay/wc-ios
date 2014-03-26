//
//  MoreTableViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import "MoreTableViewController.h"
#import "WebViewController.h"
#import "Banner.h"

@interface MoreTableViewController ()

@end

@implementation MoreTableViewController {
    NSMutableArray *moreTable;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    moreTable = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *optionsDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *optionsArray = [[NSMutableArray alloc] init];
    
    [optionsDictionary setObject:@"Extra" forKey:@"header"];
    
    NSMutableDictionary *chapelOption = [[NSMutableDictionary alloc] init];
    WebViewController *cVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    cVC.allowZoom = YES;
    cVC.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"chapel" ofType:@"pdf"]];
    [chapelOption setValue:@"Chapel Seat Layout" forKey:@"name"];
    [chapelOption setValue:cVC forKey:@"controller"];
    [optionsArray addObject:chapelOption];
    
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types != UIRemoteNotificationTypeNone) {
        NSMutableDictionary *notificationOption = [[NSMutableDictionary alloc] init];
        UIViewController *nVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationOptions"];
        nVC.title = @"Notification Toggles";
        [notificationOption setValue:nVC forKey:@"controller"];
        [notificationOption setValue:@"Notification Toggles" forKey:@"name"];
        [optionsArray addObject:notificationOption];
    }
    
    [optionsDictionary setObject:optionsArray forKey:@"array"];
    [moreTable addObject:optionsDictionary];
    
    if (types != UIRemoteNotificationTypeNone) {
        NSMutableDictionary *bannerDictionary = [[NSMutableDictionary alloc] init];
        NSMutableArray *bannerArray = [[NSMutableArray alloc] init];
        
        [bannerDictionary setObject:@"Banner" forKey:@"header"];
        
        NSMutableDictionary *bannerOption = [[NSMutableDictionary alloc] init];
        UIViewController *bVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BannerLogin"];
        [bannerOption setValue:@"Login" forKey:@"name"];
        [bannerOption setValue:bVC forKey:@"controller"];
        [bannerArray addObject:bannerOption];
        
        if ([Banner hasLoggedIn]) {
            NSMutableDictionary *degreeOption = [[NSMutableDictionary alloc] init];
            UIViewController *dVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DegreeEvaluation"];
            [degreeOption setValue:@"Degree Evaluation (Beta)" forKey:@"name"];
            [degreeOption setValue:dVC forKey:@"controller"];
            [bannerArray addObject:degreeOption];
            
            NSMutableDictionary *calendarOption = [[NSMutableDictionary alloc] init];
            UIViewController *calVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImportCalendar"];
            [calendarOption setValue:@"Import Class Schedule" forKey:@"name"];
            [calendarOption setValue:calVC forKey:@"controller"];
            [bannerArray addObject:calendarOption];
        }
        
        [bannerDictionary setObject:bannerArray forKey:@"array"];
        [moreTable addObject:bannerDictionary];
    }
    
    NSMutableDictionary *endDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *endArray = [[NSMutableArray alloc] init];
    
    [endDictionary setObject:@"" forKey:@"header"];
    
    NSMutableDictionary *aboutOption = [[NSMutableDictionary alloc] init];
    WebViewController *aVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    aVC.url = [NSURL URLWithString:c_About];
    [aboutOption setValue:@"About" forKey:@"name"];
    [aboutOption setValue:aVC forKey:@"controller"];
    [endArray addObject:aboutOption];
    
    [endDictionary setObject:endArray forKey:@"array"];
    [moreTable addObject:endDictionary];
    
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
    return [moreTable count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[moreTable objectAtIndex:section] objectForKey:@"array"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    NSDictionary *entry = [moreTable objectAtIndex:sectionIndex];
    
    return [entry objectForKey:@"header"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [[moreTable objectAtIndex:indexPath.section] objectForKey:@"array"];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"name"];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [[[moreTable objectAtIndex:indexPath.section]
                          objectForKey:@"array"]
                         objectAtIndex:indexPath.row];
    UIViewController *selected = [dic objectForKey:@"controller"];
    selected.title = [dic objectForKey:@"name"];
    [self.navigationController
     pushViewController:selected
     animated:YES];
}

@end
