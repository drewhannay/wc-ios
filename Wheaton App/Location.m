//
//  Location.m
//  Wheaton App
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import "Location.h"
#import <AddressBook/AddressBook.h>

@interface Location ()

@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end

@implementation Location

@synthesize title;

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.title = name;
        } else {
            self.title = @"Unknown location type";
        }
        self.theCoordinate = coordinate;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : @""};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    mapItem.name = self.title;
    
    return mapItem;
}

@end