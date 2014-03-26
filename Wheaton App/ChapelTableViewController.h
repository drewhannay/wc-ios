//
//  ChapelTableViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AFNetworking.h"
#import "CustomTableViewController.h"

@interface ChapelTableViewController : CustomTableViewController {
    int todayRow;
    int todaySection;
    NSCalendar *cal;
}

@property (nonatomic, retain) NSMutableArray *schedule;

@end
