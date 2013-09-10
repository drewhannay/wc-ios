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

@interface MenuTopViewController : UIViewController <NSXMLParserDelegate, UIWebViewDelegate> {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSString *element;
    NSMutableDictionary *item;
    NSMutableString *htmlCode;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView * activityView;
@property (strong, nonatomic) UIButton *menuBtn;

- (IBAction)revealMenu:(id)sender;

@end
