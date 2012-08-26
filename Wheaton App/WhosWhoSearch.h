//
//  WhosWhoSearch.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhosWhoResults.h"
#import "iToast.h"

@interface WhosWhoSearch : UIViewController <UITextFieldDelegate>
{
    NSString *searchParameter;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) IBOutlet UITextField *searchBox;

@end
