//
//  Location.h
//  Wheaton Orientation
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSArray *hours;

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end