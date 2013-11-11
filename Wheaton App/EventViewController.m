//
//  EventViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/10/13.
//
//

#import "EventViewController.h"
#import "SportsTableViewController.h"
#import "ChapelTableViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

@synthesize switchViewControllers, allViewControllers, currentViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    // Create the score view controller
//    AcademicCalendarViewController *acVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AcademicCalendar"];
    
    // Create the penalty view controller
    SportsTableViewController *sVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SportsCalendar"];
    ChapelTableViewController *cVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChapelCalendar"];
    
    // Add A and B view controllers to the array
    self.allViewControllers = [[NSArray alloc] initWithObjects:sVC, sVC, cVC, nil];
    
    // Ensure a view controller is loaded
    self.switchViewControllers.selectedSegmentIndex = 0;
    [self cycleFromViewController:self.currentViewController toViewController:[self.allViewControllers objectAtIndex:self.switchViewControllers.selectedSegmentIndex]];
    [self.switchViewControllers addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];

}

#pragma mark - View controller switching and saving

- (void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC {
    
    // Do nothing if we are attempting to swap to the same view controller
    if (newVC == oldVC) return;
    
    // Check the newVC is non-nil otherwise expect a crash: NSInvalidArgumentException
    if (newVC) {
        
        newVC.view.frame = CGRectMake(CGRectGetMinX(self.viewContainer.bounds), CGRectGetMinY(self.viewContainer.bounds), CGRectGetWidth(self.viewContainer.bounds), CGRectGetHeight(self.viewContainer.bounds)-self.tabBarController.tabBar.frame.size.height);
        
        // Check the oldVC is non-nil otherwise expect a crash: NSInvalidArgumentException
        if (oldVC) {
            
            // Start both the view controller transitions
            [oldVC willMoveToParentViewController:nil];
            [self addChildViewController:newVC];
            
            // Swap the view controllers
            // No frame animations in this code but these would go in the animations block
            [self transitionFromViewController:oldVC
                              toViewController:newVC
                                      duration:0.25
                                       options:UIViewAnimationOptionLayoutSubviews
                                    animations:^{}
                                    completion:^(BOOL finished) {
                                        // Finish both the view controller transitions
                                        [oldVC removeFromParentViewController];
                                        [newVC didMoveToParentViewController:self];
                                        // Store a reference to the current controller
                                        self.currentViewController = newVC;
                                    }];
            
        } else {
            
            // Otherwise we are adding a view controller for the first time
            // Start the view controller transition
            [self addChildViewController:newVC];
            
            [self.viewContainer addSubview:newVC.view];
            
            // End the view controller transition
            [newVC didMoveToParentViewController:self];
            
            // Store a reference to the current controller
            self.currentViewController = newVC;
        }
    }
}

- (IBAction)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender {
    
    NSUInteger index = sender.selectedSegmentIndex;
    
    if (UISegmentedControlNoSegment != index) {
        UIViewController *incomingViewController = [self.allViewControllers objectAtIndex:index];
        [self cycleFromViewController:self.currentViewController toViewController:incomingViewController];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
