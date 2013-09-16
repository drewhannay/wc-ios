//
//  HomeTopViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 3/28/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>
#import "ECSlidingViewController.h"
#import "HomeSportsCollectionViewController.h"
#import "MenuViewController.h"
#import "HomeView.h"

@interface HomeTopViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *tweetSend;
@property (strong, nonatomic) IBOutlet HomeView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *sportsLabel;
@property (strong, nonatomic) IBOutlet UILabel *happeningLabel;
@property (weak, nonatomic) HomeSportsCollectionViewController *sportsVC;
@property (strong, nonatomic) UIButton *menuBtn;

- (IBAction)revealMenu:(id)sender;
- (IBAction)tweet:(id)sender;
- (void)addBorder:(UILabel *)lbl;


@end
