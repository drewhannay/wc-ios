
//
//  Map.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "Map.h"
#import "MapKit/MapKit.h"
#import "HomeScreen.h"


@implementation Map

@synthesize mapView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mapView.mapType = MKMapTypeHybrid;

    urlMap = [[NSMutableDictionary alloc] init];
    urlMapIndex = 0;

    CLLocationCoordinate2D coords;
    coords.latitude = 41.870024;
    coords.longitude = -88.098384;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coords, 150, 150);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: MAP_PINS_URL]];
        NSArray *cachesDirList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDir = [cachesDirList objectAtIndex:0];
        if (data != nil)
            [data writeToURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", cacheDir, @"mapPins.json"]] atomically:YES];
        else
            data = [NSData dataWithContentsOfURL: [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", cacheDir, @"mapPins.json"]]];

        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *)responseData
{
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray* pins = [json objectForKey:@"pins"];
    
    CLLocationCoordinate2D coords;
    for (NSDictionary *pin in pins)
    {
        coords.latitude = [[pin objectForKey:@"latitude"] doubleValue];
        coords.longitude = [[pin objectForKey:@"longitude"] doubleValue];
        PinAnnotation *pinAnnotation = [[PinAnnotation alloc] initWithCoordinate:coords title:[pin objectForKey:@"name"]];
        
        if ([pin objectForKey:@"isPurple"] != nil)
            pinAnnotation.isPurple = true;
        
        NSString *url = [pin objectForKey:@"url"];
        if (url != nil)
            pinAnnotation.url = url;
        
        [mapView addAnnotation:pinAnnotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our custom annotation
    if ([annotation isKindOfClass:[PinAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* PinAnnotationIdentifier = @"pinAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:PinAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PinAnnotationIdentifier];
            if (((PinAnnotation *) annotation).isPurple)
                customPinView.pinColor = MKPinAnnotationColorPurple;
            else
                customPinView.pinColor = MKPinAnnotationColorRed;
            
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            NSString *url = ((PinAnnotation *) annotation).url;
            if (url != nil)
            {
                // add a detail disclosure button to the callout which will open a new view controller page
                UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                rightButton.tag = ++urlMapIndex;
                [urlMap setObject:url forKey:[NSString stringWithFormat:@"%d", urlMapIndex]];
                [rightButton addTarget:self action:@selector(showWebLink:) forControlEvents:UIControlEventTouchUpInside];
                customPinView.rightCalloutAccessoryView = rightButton;
			}
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

-(void) showWebLink: (UIButton *) sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [urlMap objectForKey:[NSString stringWithFormat:@"%d",sender.tag]]]];
}

@end
