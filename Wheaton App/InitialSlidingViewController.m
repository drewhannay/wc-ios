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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
