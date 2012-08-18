//
//  DiningMenu.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DiningMenu : UIViewController <UIWebViewDelegate>
{
    UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
