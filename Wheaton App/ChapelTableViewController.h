//
//  ChapelTableViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface ChapelTableViewController : UITableViewController {
    int todayRow;
    int todaySection;
    NSCalendar *cal;
}

@property (nonatomic, retain) NSMutableArray *schedule;

@end
