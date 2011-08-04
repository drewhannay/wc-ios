//
//  About.h
//  Wheaton App
//
//  Created by support on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface About : UIViewController {
    
    UIButton *dismiss;
    
}

@property (nonatomic, retain) IBOutlet UIButton *dismiss;

-(IBAction) dismissView:(id) sender;

@end
