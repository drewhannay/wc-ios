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

@interface MasterTabViewController ()

@end

@implementation MasterTabViewController
{
    NSInteger index;
}

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
