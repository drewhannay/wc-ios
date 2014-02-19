//
//  MapViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import "MapViewController.h"
#import "MapDetailViewController.h"
#import "Location.h"

#define METERS_PER_MILE 1609.344

@implementation MapViewController

@synthesize locations, searchController;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    barHidden = NO;
    self.screenName = @"Map";
    
    UITextView *searchTextField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
    searchTextField.textColor = [UIColor whiteColor];
    
    [self loadLocations];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Opened Map" properties:@{}];
    
    [self resetMap:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)tapped
{
    [self resetMap:NULL];
}

- (IBAction)resetMap:(id)sender
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (Location *annotation in locations) {
        if ([annotation.type isEqualToString:@"building"]) {
            [self.mapView addAnnotation:annotation];
        }
    }
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 41.870016;
    zoomLocation.longitude = -88.098362;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.075*METERS_PER_MILE, 0.075*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"Location";
    
    if ([annotation isKindOfClass:[Location class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.animatesDrop = YES;
            annotationView.canShowCallout = YES;
            if ((annotation.description != (id)[NSNull null])
                && (annotation.description.length > 0)) {
                annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            } else {
                annotationView.rightCalloutAccessoryView = NULL;
            }
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    return nil;
}
- (void)mapView:(MKMapView *)mv annotationView:(MKAnnotationView *)pin calloutAccessoryControlTapped:(UIControl *)control {
    Location *loc = pin.annotation;
    [self performSegueWithIdentifier:@"MapDetailView" sender:loc];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapDetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.building = sender;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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
        
        @try {
            NSDictionary *location = [dic objectForKey:@"location"];
            NSNumber *latitude = [location objectForKey:@"latitude"];
            NSNumber *longitude = [location objectForKey:@"longitude"];
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = latitude.doubleValue;
            coordinate.longitude = longitude.doubleValue;
            
            Location *annotation = [[Location alloc] initWithName:[dic objectForKey:@"name"] coordinate:coordinate];
            annotation.image = @"";
            if (![[[dic objectForKey:@"image"] objectForKey:@"url"] isEqual:[NSNull null]]) {
                annotation.image = [[[dic objectForKey:@"image"] objectForKey:@"url"] objectForKey:@"medium"];
            }
            annotation.description = @"Blank";
            if (![[dic objectForKey:@"description"] isEqual:[NSNull null]]) {
                annotation.description = [dic objectForKey:@"description"];
            }
            annotation.type = [dic objectForKey:@"type"];
            annotation.hours = [dic objectForKey:@"hours"];
            
            if ([[dic objectForKey:@"type"] isEqualToString:@"building"]) {
                [self.mapView addAnnotation:annotation];
            }
            [locations addObject:annotation];
        } @catch (NSException * e) { }
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



- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) keyboardWillHide {
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
