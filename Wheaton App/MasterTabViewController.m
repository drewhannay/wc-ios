//
//  MasterTabViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/7/13.
//
//

#import "MasterTabViewController.h"
#import "MapViewController.h"
#import "WebViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MasterTabViewController ()

@end

@implementation MasterTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UITabBar appearance] setTintColor:UIColorFromRGB(0xe36f1e)];
    
    WebViewController *mealMenu = (WebViewController *)[self.viewControllers objectAtIndex:2];
    mealMenu.url = [NSURL URLWithString:c_Menu];
    mealMenu.allowResize = NO;
    self.delegate = self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([self selectedIndex] == 3) {
        [([[(MapViewController *)[self selectedViewController] childViewControllers] objectAtIndex:0]) tapped];
    }
    index = [self selectedIndex];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
