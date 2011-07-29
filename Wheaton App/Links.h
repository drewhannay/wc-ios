//
//  Links.h
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Links : UIViewController
    <UITableViewDataSource,
    UITableViewDelegate> {
        NSDictionary *linksList;
}

@property (nonatomic, retain) NSDictionary *linksList;

@end
