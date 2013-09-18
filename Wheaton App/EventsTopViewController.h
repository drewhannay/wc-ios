//
//  EventsTopViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 9/8/13.
//
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface EventsTopViewController : UIViewController <UITableViewDataSource, UITabBarControllerDelegate, NSXMLParserDelegate> { 
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *date;
    NSString *element;
    NSDateFormatter *dateFormatter;
    NSCalendar *calendar;
}

@property (nonatomic, retain) NSMutableArray *schedule;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) UIButton *menuBtn;

- (IBAction)revealMenu:(id)sender;

@end
