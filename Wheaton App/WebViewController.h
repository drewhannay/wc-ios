//
//  WebViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 12/6/13.
//
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) NSURL *url;
@property BOOL allowZoom;
@property BOOL allowResize;
@property BOOL refresh;

@end
