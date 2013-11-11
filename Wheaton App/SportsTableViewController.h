//
//  SportsTableViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/10/13.
//
//

#import <UIKit/UIKit.h>
#import "MasterTabViewController.h"

@interface SportsTableViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *sportResults;
@property NSInteger *displayResults;

@end
