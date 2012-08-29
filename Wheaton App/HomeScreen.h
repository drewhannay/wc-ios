//
//  HomeScreen.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhosWhoSearch.h"
#import "DiningMenu.h"
#import "Chapel.h"
#import "OpenFloor.h"
#import "Links.h"
#import "Map.h"
#import "About.h"

extern NSString *const CHAPEL_URL;
extern NSString *const MAP_PINS_URL;
extern NSString *const MENU_URL;
extern NSString *const OPEN_FLOOR_URL;
extern NSString *const WHOS_WHO_PREFIX;

@interface HomeScreen : UIViewController<UIScrollViewDelegate>
{
    WhosWhoSearch *whosWhoSearch;
    DiningMenu *diningMenu;
    Links *links;
    About *about;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) IBOutlet UIButton *whosWhoButton;
@property (nonatomic, retain) IBOutlet UIButton *diningMenuButton;
@property (nonatomic, retain) IBOutlet UIButton *chapelButton;
@property (nonatomic, retain) IBOutlet UIButton *openFloorButton;
@property (nonatomic, retain) IBOutlet UIButton *mapButton;
@property (nonatomic, retain) IBOutlet UIButton *linksButton;
@property (nonatomic, retain) IBOutlet UIButton *aboutButton;

@end
