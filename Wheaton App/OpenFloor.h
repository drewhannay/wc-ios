//
//  OpenFloor.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OpenFloor : UIViewController
{
    NSArray *m_openFloorDays;
    NSDateFormatter *m_dateFormatter;
    NSDate *m_latestDate;
    int m_todayIndex;
    int m_viewIndex;
    BOOL m_errorOccurred;
    BOOL m_isWorking;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIButton *todayButton;
@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;

-(IBAction)switchPage:(UIButton *)button;

@end
