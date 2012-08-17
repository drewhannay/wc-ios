//
//  PinAnnotation.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "PinAnnotation.h"


@implementation PinAnnotation

@synthesize coordinate;
@synthesize title;

-(NSString *) title
{
    return title;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)c 
                   title:(NSString *)t
{
    coordinate = c;
    self.title = t;
    return self;
}

@end
