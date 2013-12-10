//
//  EventDetailViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 12/6/13.
//
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) NSString *urlString;

@end
