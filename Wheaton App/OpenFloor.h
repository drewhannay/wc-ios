//
//  OpenFloor.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OpenFloor : UIViewController {
    UIActivityIndicatorView *loadingView;
    UIWebView *webView;
    UIButton *todayButton;
    UIButton *prevButton;
    UIButton *nextButton;
    NSArray *results;
    int viewIndex;
    int todayIndex;

}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIButton *todayButton;
@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) NSArray *results;

-(void) loadData;
-(IBAction) switchPage:(UIButton *)button;
- (void)spinBegin;
- (void)spinEnd;
-(void) viewDidAppear:(BOOL)animated;


@end
