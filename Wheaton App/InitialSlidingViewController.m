//
//  InitialSlidingViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import "InitialSlidingViewController.h"

@implementation InitialSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTop"];
//    
//    UIViewController *newTopViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTop"];
//
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//         self.topViewController.view.frame = newTopViewController.view.frame = CGRectMake(
//                                                                             newTopViewController.view.frame.origin.x,
//                                                                             20,
//                                                                             newTopViewController.view.frame.size.width,
//                                                                             self.view.window.frame.size.height-20);
//    }
//    
//    CGRect frame = newTopViewController.view.frame;
//    newTopViewController.view.frame = frame;
//    self.topViewController = newTopViewController;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
