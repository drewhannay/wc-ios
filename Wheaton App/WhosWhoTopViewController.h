//
//  WhosWhoTopViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 8/28/13.
//
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface WhosWhoTopViewController : UINavigationController <UISearchBarDelegate>

@property (strong, nonatomic) UIButton *menuBtn;

- (IBAction)revealMenu:(id)sender;

@end


