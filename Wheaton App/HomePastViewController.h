//
//  HomePastViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 12/14/13.
//
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Constants.h"
#import "HomeView.h"

@interface HomePastViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *home;
@property (strong, nonatomic) IBOutlet HomeView *scrollView;

@end
