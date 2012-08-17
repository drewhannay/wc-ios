//
//  Links.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Links : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
}

@property (nonatomic, retain) NSDictionary *linksList;

@end
