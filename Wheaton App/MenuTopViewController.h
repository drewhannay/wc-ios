//
//  MenuTopViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 8/28/13.
//
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface MenuTopViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView * activityView;
@property (strong, nonatomic) UIButton *menuBtn;

- (IBAction)revealMenu:(id)sender;

@end
