//
//  WhosWhoTopViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 8/28/13.
//
//

#import "WhosWhoTopViewController.h"

@interface WhosWhoTopViewController ()

@end

@implementation WhosWhoTopViewController

@synthesize menuBtn = _menuBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.underRightViewController = nil;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuBtn.frame = CGRectMake(4, 0, 44, 44);
    [self.menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [self.menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:self.menuBtn];
    [self.navigationBar addSubview:anotherButton.customView];
    [self.navigationItem setLeftBarButtonItem:anotherButton];
    
    //[self.view addSubview:self.menuBtn];
    
    [super viewDidLoad];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
