//
//  HomeViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "Reachability.h"
#import "MTReachabilityManager.h"
#import "LVDebounce.h"

@interface HomeViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSInteger priorSegmentIndex;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *switchViewControllers;
@property (nonatomic, copy) NSArray *allViewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (nonatomic, retain) NSMutableArray *searchResults;

- (void)performSearch:(NSTimer *)timer;

@end
