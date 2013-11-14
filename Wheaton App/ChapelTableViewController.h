//
//  ChapelTableViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import <UIKit/UIKit.h>

@interface ChapelTableViewController : UITableViewController {
    int todayRow;
    int todaySection;
}

@property (nonatomic, retain) NSMutableArray *schedule;

@end
