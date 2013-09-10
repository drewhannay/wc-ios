//
//  WhosWhoResultsTopViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 8/28/13.
//
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface WhosWhoResultsTopViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSString *searchParameter;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBox;
@property (nonatomic, retain) IBOutlet UITableView *resultsList;
@property (nonatomic, retain) NSArray *searchResults;

@end


