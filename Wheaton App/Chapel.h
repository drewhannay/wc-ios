//
//  Chapel.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Chapel : UIViewController
{
    NSMutableArray *m_chapelWeeks;
    NSMutableString *m_currentWeek;
    NSDateFormatter *m_dateFormatter;
    NSString *m_lastDay;
    int m_viewIndex;
    int m_todayIndex;
    BOOL m_isWorking;
    BOOL m_errorOccurred;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIButton *todayButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *previousButton;

@end
