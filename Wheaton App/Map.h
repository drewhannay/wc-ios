//
//  Map.h
//  Wheaton App
//
//  Created by support on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "PinAnnotation.h"


@interface Map : UIViewController
    <MKMapViewDelegate> {
    MKMapView *mapView;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end
