//
//  HomeScreen.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StalkernetHome.h"
#import "DiningMenu.h"
#import "Chapel.h"
#import "OpenFloor.h"
#import "Links.h"
#import "Map.h"
#import "About.h"


@interface HomeScreen : UIViewController<UIScrollViewDelegate>{
    UIScrollView *scrollView;
    UIActivityIndicatorView *loadingView;
    StalkernetHome *stalkernetHome;
    DiningMenu *diningMenu;
    Chapel *chapel;
    OpenFloor *openFloor;
    Map *map;
    Links *links;
    About *about;
    UIButton *stalkernetButton;
    UIButton *diningMenuButton;
    UIButton *chapelButton;
    UIButton *openFloorButton;
    UIButton *mapButton;
    UIButton *linksButton;
    UIButton *aboutButton;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) StalkernetHome *stalkernetHome;
@property (nonatomic, retain) DiningMenu *diningMenu;
@property (nonatomic, retain) Chapel *chapel;
@property (nonatomic, retain) OpenFloor *openFloor;
@property (nonatomic, retain) Map *map;
@property (nonatomic, retain) Links *links;
@property (nonatomic, retain) About *about;
@property (nonatomic, retain) IBOutlet UIButton *stalkernetButton;
@property (nonatomic, retain) IBOutlet UIButton *diningMenuButton;
@property (nonatomic, retain) IBOutlet UIButton *chapelButton;
@property (nonatomic, retain) IBOutlet UIButton *openFloorButton;
@property (nonatomic, retain) IBOutlet UIButton *mapButton;
@property (nonatomic, retain) IBOutlet UIButton *linksButton;
@property (nonatomic, retain) IBOutlet UIButton *aboutButton;

-(IBAction)launchPage:(UIButton *) button;
- (void)spinBegin;
- (void)spinEnd;

@end
