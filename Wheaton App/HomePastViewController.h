//
//  HomePastViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 12/14/13.
//
//

#import <UIKit/UIKit.h>
#import "BannerScrollView.h"

@interface HomePastViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *home;
@property (strong, nonatomic) IBOutlet BannerScrollView *scrollView;

@end
