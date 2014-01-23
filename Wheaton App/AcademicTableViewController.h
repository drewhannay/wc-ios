//
//  AcademicTableViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/13/13.
//
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface AcademicTableViewController : UITableViewController {
    NSCalendar *cal;
}


@property (nonatomic, retain) NSMutableArray *calendar;

@end
