//
//  MapViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import "MapViewController.h"
#import "MasterTabViewController.h"
#import "Location.h"

#define METERS_PER_MILE 1609.344

@implementation MapViewController

@synthesize locations, searchController;


- (void)viewDidAppear:(BOOL)animated
{
    [self resetMap:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    barHidden = NO;
    self.screenName = @"Map";
    
    UITextView *searchTextField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
    searchTextField.textColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(showNavbar:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(hideNavbar:)];
    [self.mapView addGestureRecognizer:tapGesture];
    [panGesture setDelegate:self];
    [self.mapView addGestureRecognizer:panGesture];
    
    [self loadLocations];
}

- (IBAction)resetMap:(id)sender {
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (Location *annotation in locations) {
        [self.mapView addAnnotation:annotation];
    }
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 41.870016;
    zoomLocation.longitude = -88.098362;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.075*METERS_PER_MILE, 0.075*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"Location";
    
    if ([annotation isKindOfClass:[Location class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    return nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"drag start");
    }
}


- (void)loadLocations
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString: c_MapLocations]];
        NSArray *cachesDirList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDir = [cachesDirList objectAtIndex:0];
        if (data != nil) {
            [data writeToURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", cacheDir, @"mapPins.json"]] atomically:YES];
        } else {
            data = [NSData dataWithContentsOfURL: [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", cacheDir, @"mapPins.json"]]];
        }
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void) hideNavbar:(id) sender
{
    if (barHidden == NO) {
        self.tabBarController.tabBar.translucent = YES;
        CGRect tabBarFrame = self.tabBarController.tabBar.frame;
        tabBarFrame.origin.y += tabBarFrame.size.height;
        
        [UIView animateWithDuration:0.2 animations:^ {
            [self.tabBarController.tabBar setFrame:tabBarFrame];
        }];
        barHidden = YES;
    }
}

-(void) showNavbar:(id) sender
{
    if (barHidden == YES) {
        CGRect tabBarFrame = self.tabBarController.tabBar.frame;
        tabBarFrame.origin.y -= tabBarFrame.size.height;
        
        [UIView animateWithDuration:0.1 animations:^ {
            [self.tabBarController.tabBar setFrame:tabBarFrame];
        }];
        self.tabBarController.tabBar.translucent = NO;
        barHidden = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MapSearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = ((Location *)[searchResults objectAtIndex:indexPath.row]).title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location *annotation = (Location *)[searchResults objectAtIndex:indexPath.row];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:annotation];
    [self.searchDisplayController setActive:NO];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 0.075*METERS_PER_MILE, 0.075*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}


- (void)fetchedData:(id)responseData
{
    if (responseData == nil) {
        return;
    }
    NSError* error;
    NSArray *locationArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    locations = [[NSMutableArray alloc] init];
    
    for (NSDictionary* dic in locationArray) {
        
        NSDictionary *location = [dic objectForKey:@"location"];
        NSNumber * latitude = [location objectForKey:@"latitude"];
        NSNumber * longitude = [location objectForKey:@"longitude"];
        NSString * name = [dic objectForKey:@"name"];
        NSString * address = @"";
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        Location *annotation = [[Location alloc] initWithName:name address:address coordinate:coordinate];
        if([[dic objectForKey:@"type"] isEqualToString:@"building"])
            [self.mapView addAnnotation:annotation];
        [locations addObject:annotation];
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"title contains[cd] %@",
                                    searchText];
    
    searchResults = [locations filteredArrayUsingPredicate:resultPredicate];
}

#pragma mark - UISearchDisplayController delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
