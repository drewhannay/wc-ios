//
//  SportsTopViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 9/13/13.
//
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "HomeSportsCollectionViewController.h"

@interface SportsTopViewController : UIViewController

@property (strong, nonatomic) UIButton *menuBtn;
@property (weak, nonatomic) HomeSportsCollectionViewController *sportsVC;

- (IBAction)revealMenu:(id)sender;

@end
