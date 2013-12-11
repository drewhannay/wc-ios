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

@property (nonatomic, retain) NSMutableDictionary *sportResults;
@property NSInteger *displayResults;

@end
