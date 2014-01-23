//
//  NotificationOptionsTableViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/17/13.
//
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface NotificationOptionsTableViewController : UITableViewController {
    AFHTTPRequestOperationManager *manager;
}

@property (nonatomic, retain) NSMutableArray *notificationOptions;

@end
