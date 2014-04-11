//
//  SportsTableViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/10/13.
//
//

#import <UIKit/UIKit.h>
#import "CustomTableViewController.h"

@interface SportsTableViewController : CustomTableViewController

@property (nonatomic, retain) NSMutableDictionary *sportResults;
@property NSInteger *displayResults;

@end
