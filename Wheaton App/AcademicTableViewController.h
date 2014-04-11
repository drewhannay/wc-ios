//
//  AcademicTableViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/13/13.
//
//

#import <UIKit/UIKit.h>
#import "CustomTableViewController.h"

@interface AcademicTableViewController : CustomTableViewController {
    NSCalendar *cal;
}


@property (nonatomic, retain) NSMutableArray *calendar;

@end
