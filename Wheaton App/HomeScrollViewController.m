//
//  HomeScrollViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/14/13.
//
//

#import "HomeScrollViewController.h"

@interface HomeScrollViewController ()

@end

@implementation HomeScrollViewController

@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    scrollView.contentSize = CGSizeMake(320, 800);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
