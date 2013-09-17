//
//  MenuViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import "MenuViewController.h"
#import "SideBarTableCell.h"
#import "MTReachabilityManager.h"

NSString * const c_MapLocations = @"https://s3.amazonaws.com/wcstatic/location.json";
NSString * const c_Chapel = @"https://s3.amazonaws.com/wcstatic/chapel.json";
NSString * const c_Menu = @"http://legacy.cafebonappetit.com/rss/menu/339";
NSString * const c_Whoswho = @"https://webapp.wheaton.edu/whoswho/person/searchJson?page_size=100&q=2%20";
NSString * const c_Sports = @"https://s3.amazonaws.com/wcstatic/sports_calendar.json";
NSString * const c_Academic = @"http://25livepub.collegenet.com/calendars/event-collections-general_calendar_wp.rss";
NSString * const c_Events = @"http://25livepub.collegenet.com/calendars/intra-campus-calendar.rss";
NSString * const c_Banners = @"https://s3.amazonaws.com/wcstatic/banners.json";

@interface MenuViewController()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MenuViewController
@synthesize menuItems, table;

- (void)awakeFromNib
{
    self.menuItems = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"Home", @"House.png", @"Home", nil],
                      [NSArray arrayWithObjects:@"Campus Map", @"Map.png", @"Map", nil],
                      [NSArray arrayWithObjects:@"Chapel Schedule", @"Chapel.png", @"Chapel", nil],
                      [NSArray arrayWithObjects:@"Who's Who", @"Whoswho.png", @"Whoswho", nil],
                      [NSArray arrayWithObjects:@"Academic Calendar", @"Calendar.png", @"Academic", nil],
                      [NSArray arrayWithObjects:@"Sports", @"Sports.png", @"Sports", nil],
                      [NSArray arrayWithObjects:@"Meal Menu", @"Meal.png", @"Menu", nil], nil];
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.slidingViewController setAnchorRightRevealAmount:240.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    table.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SideBarTableCell *cell = (SideBarTableCell *)[tableView dequeueReusableCellWithIdentifier:@"SideBarTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SideBarTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.itemLabel.text = [[self.menuItems objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.icon.image = [UIImage imageNamed:[[self.menuItems objectAtIndex:indexPath.row] objectAtIndex:1]];
    
//    if([[[self.menuItems objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@"Whoswho"] && ![MTReachabilityManager isReachableViaWiFi]) {
//        
//        Need to find different solution. Because menu is infrequently drawn need to find alternative (possible notifications)
//        [cell.itemLabel setTextColor:[UIColor lightGrayColor]];
//        
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[self.menuItems objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@"Whoswho"]
       && ![MTReachabilityManager isReachableViaWiFi]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to fetch results"
                                                        message:@"You must be connected to Wheaton College Wifi to use this feature."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        NSString *identifier = [NSString stringWithFormat:@"%@Top", [[self.menuItems objectAtIndex:indexPath.row] objectAtIndex:2]];
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            int position = -1;
            if([identifier isEqualToString:@"HomeTop"]) {
                position = 0;
            }
            self.slidingViewController.topViewController.view.frame = CGRectMake(
                                                                                 self.slidingViewController.topViewController.view.frame.origin.x,
                                                                                 position,
                                                                                 self.slidingViewController.topViewController.view.frame.size.width,
                                                                                 self.view.window.frame.size.height + 1);
        }
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
}

@end
