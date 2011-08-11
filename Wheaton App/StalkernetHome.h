//
//  StalkernetHome.h
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StalkernetHome : UIViewController {
    UITextField *searchBox;
    UIButton *searchButton;
}

@property (nonatomic, retain) IBOutlet UITextField *searchBox;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;

-(IBAction) runSearch;

@end
