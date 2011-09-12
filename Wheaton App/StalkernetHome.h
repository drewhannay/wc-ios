//
//  StalkernetHome.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StalkernetResults.h"
#import "iToast.h"

@interface StalkernetHome : UIViewController 
    <UITextFieldDelegate>{
        UIActivityIndicatorView *loadingView;
        UITextField *searchBox;
        UIButton *searchButton;
        StalkernetResults *resultScreen;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) IBOutlet UITextField *searchBox;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;
@property (nonatomic, retain) StalkernetResults *resultScreen;

-(IBAction) runSearch;

@end
