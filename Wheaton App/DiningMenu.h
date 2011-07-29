//
//  DiningMenu.h
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DiningMenu : UIViewController {
    UIWebView *webView;
    UIButton *todayButton;
    UIButton *prevButton;
    UIButton *nextButton;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIButton *todayButton;
@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;

-(IBAction) switchPage:(UIButton *)id;

@end
