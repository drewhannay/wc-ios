//
//  EventsTableViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/13/13.
//
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface EventsTableViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *eventResults;
@property NSInteger *displayResults;

@end
