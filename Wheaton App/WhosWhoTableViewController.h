//
//  WhosWhoTableViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 12/6/13.
//
//

#import <UIKit/UIKit.h>

@interface WhosWhoTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, retain) NSMutableArray *people;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
