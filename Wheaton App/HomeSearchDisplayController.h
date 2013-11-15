//
//  HomeSearchDisplayController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/12/13.
//
//

#import <UIKit/UIKit.h>

@interface HomeSearchDisplayController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate> {
    NSArray *searchResults;
}

@property (nonatomic, retain) NSMutableArray *people;
@property (strong, nonatomic) UISearchDisplayController *searchController;

- (void)makeSearch:(NSString *)filter;

@end
