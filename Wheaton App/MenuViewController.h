//
//  MenuViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

extern NSString * const c_FAQUrl;
extern NSString * const c_WeatherUrl;
extern NSString * const c_MapLocations;
extern NSString * const c_Chapel;
extern NSString * const c_Whoswho;
extern NSString * const c_Menu;
extern NSString * const c_Sports;
extern NSString * const c_Events;

@interface MenuViewController : UIViewController <UITableViewDataSource, UITabBarControllerDelegate>

@end
