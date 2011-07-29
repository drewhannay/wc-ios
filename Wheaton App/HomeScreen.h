//
//  HomeScreen.h
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StalkernetHome.h"
#import "DiningMenu.h"
#import "Chapel.h"
#import "Links.h"
#import "Map.h"


@interface HomeScreen : UIViewController {
    UIActivityIndicatorView *loadingView;
    StalkernetHome *stalkernetHome;
    DiningMenu *diningMenu;
    Chapel *chapel;
    Map *map;
    Links *links;
    UIButton *stalkernetButton;
    UIButton *diningMenuButton;
    UIButton *chapelButton;
    UIButton *mapButton;
    UIButton *linksButton;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) StalkernetHome *stalkernetHome;
@property (nonatomic, retain) DiningMenu *diningMenu;
@property (nonatomic, retain) Chapel *chapel;
@property (nonatomic, retain) Map *map;
@property (nonatomic, retain) Links *links;
@property (nonatomic, retain) IBOutlet UIButton *stalkernetButton;
@property (nonatomic, retain) IBOutlet UIButton *diningMenuButton;
@property (nonatomic, retain) IBOutlet UIButton *chapelButton;
@property (nonatomic, retain) IBOutlet UIButton *mapButton;
@property (nonatomic, retain) IBOutlet UIButton *linksButton;

-(IBAction)launchPage:(UIButton *) button;
- (void)spinBegin;
- (void)spinEnd;

@end
