//
//  HomeViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UISearchBarDelegate> {
    NSArray *searchResults;
}

@property (nonatomic, retain) NSMutableArray *people;
@property (strong, nonatomic) UISearchDisplayController *searchController;

@end
