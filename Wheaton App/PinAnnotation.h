//
//  PinAnnotation.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"


@interface PinAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

-(id) initWithCoordinate: (CLLocationCoordinate2D) c
                   title: (NSString *) t;
-(NSString *) title;

@end
