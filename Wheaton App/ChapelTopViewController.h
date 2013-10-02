//
//  ChapelTopViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 8/26/13.
//
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface ChapelTopViewController : GAITrackedViewController <UITableViewDataSource, UITabBarControllerDelegate>

@property (nonatomic, retain) NSMutableArray *schedule;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) UIButton *menuBtn;

- (IBAction)revealMenu:(id)sender;

@end
