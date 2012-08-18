//
//  Map.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "PinAnnotation.h"


@interface Map : UIViewController <MKMapViewDelegate>
{
    MKMapView *mapView;
    NSMutableDictionary *urlMap;
    int urlMapIndex;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end
