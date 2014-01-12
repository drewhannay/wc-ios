//
//  MasterTabViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/7/13.
//
//

#import "MasterTabViewController.h"
#import "MapViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

NSString * const c_MapLocations = @"https://isoncamp.us/wheaton/locations";
NSString * const c_Chapel = @"https://isoncamp.us/wheaton/chapel";
NSString * const c_Menu = @"https://isoncamp.us/wheaton/menu";
NSString * const c_Whoswho = @"https://isoncamp.us/wheaton/person";
NSString * const c_Sports = @"https://isoncamp.us/wheaton/sports";
NSString * const c_Academic = @"https://isoncamp.us/wheaton/academic";
NSString * const c_Banners = @"https://s3.amazonaws.com/wcstatic/banners.json";
NSString * const c_Events = @"https://isoncamp.us/wheaton/events";
NSString * const c_PushOptions = @"https://isoncamp.us/apn";

//NSString * const c_MapLocations = @"http://localhost:3000/wheaton/locations";
//NSString * const c_Chapel = @"http://localhost:3000/wheaton/chapel";
//NSString * const c_Menu = @"http://localhost:3000/wheaton/menu";
//NSString * const c_Whoswho = @"http://localhost:3000/wheaton/person";
//NSString * const c_Sports = @"http://localhost:3000/wheaton/sports";
//NSString * const c_Academic = @"http://localhost:3000/wheaton/academic";
//NSString * const c_Banners = @"https://s3.amazonaws.com/wcstatic/banners.json";
//NSString * const c_Events = @"http://localhost:3000/wheaton/events";
//NSString * const c_PushOptions = @"https://isoncamp.us/apn";

@interface MasterTabViewController ()

@end

@implementation MasterTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UITabBar appearance] setTintColor:UIColorFromRGB(0xe36f1e)];
    self.delegate = self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([self selectedIndex] == 1) {
        [((MapViewController *)[self selectedViewController]) tapped];
    }
    index = [self selectedIndex];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
