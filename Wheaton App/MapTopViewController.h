//
//  MapTopViewController.h
//  Wheaton Orientation
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface MapTopViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate> {
    NSArray *searchResults;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *location;
@property (strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) UISearchDisplayController *searchController;

- (IBAction)revealMenu:(id)sender;
@end
