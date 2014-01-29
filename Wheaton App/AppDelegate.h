//
//  AppDelegate.h
//  Wheaton App
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, MixpanelDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Mixpanel *mixpanel;

@end
