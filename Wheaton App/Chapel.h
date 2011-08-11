//
//  Chapel.h
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Chapel : UIViewController {
    UIActivityIndicatorView *loadingView;
    UIWebView *webView;
    UIButton *todayButton;
    UIButton *prevButton;
    UIButton *nextButton;
    NSArray *results;
    int viewIndex;
    int todayIndex;
    int currDay;
    int prevDay;
    int fullDay;
    BOOL indexSet;
    
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIButton *todayButton;
@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) NSArray *results;

-(void) loadData;
-(NSString *) parseDay: (NSString *)text;
-(IBAction) switchPage:(UIButton *)button;
- (void)spinBegin;
- (void)spinEnd;
-(void) viewDidAppear:(BOOL)animated;
-(BOOL) addDay:(NSString*)day;

@end
