//
//  EventViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/10/13.
//
//

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *switchViewControllers;
@property (nonatomic, copy) NSArray *allViewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end
