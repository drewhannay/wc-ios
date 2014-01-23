//
//  WhosWhoTableViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 12/6/13.
//
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface WhosWhoTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, retain) NSMutableArray *people;
@property (nonatomic, retain) NSArray *searchResults;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
