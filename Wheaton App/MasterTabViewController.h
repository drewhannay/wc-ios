//
//  MasterTabViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/7/13.
//
//

#import <UIKit/UIKit.h>

extern NSString * const c_Home;
extern NSString * const c_MapLocations;
extern NSString * const c_Chapel;
extern NSString * const c_Whoswho;
extern NSString * const c_Menu;
extern NSString * const c_Sports;
extern NSString * const c_Events;
extern NSString * const c_Academic;
extern NSString * const c_Banners;
extern NSString * const c_PushOptions;

@interface MasterTabViewController : UITabBarController <UITabBarControllerDelegate> {
    int index;
}

@end
