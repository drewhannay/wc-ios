//
//  MenuViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * activityView;

@end
