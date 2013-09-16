//
//  CustomNavBar.m
//  Wheaton App
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import "CustomNavBar.h"

@implementation CustomNavBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    UIImage *image = [UIImage imageNamed:@"CustomNav.png"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        image = [UIImage imageNamed:@"CustomNaviOS7.png"];
    }
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
