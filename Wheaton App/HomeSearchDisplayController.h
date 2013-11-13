//
//  HomeSearchDisplayController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/12/13.
//
//

#import <UIKit/UIKit.h>

@interface HomeSearchDisplayController : UISearchDisplayController <UISearchBarDelegate> {
    NSArray *searchResults;
}

@property (nonatomic, retain) NSMutableArray *people;

- (void)makeSearch:(NSString *)filter;

@end
