//
//  MapTopViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import "MapTopViewController.h"
#import "Location.h"

#define METERS_PER_MILE 1609.344

@implementation MapTopViewController

@synthesize menuBtn, location, searchController;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.underRightViewController = nil;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 41.870016;
    zoomLocation.longitude= -88.098362;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.075*METERS_PER_MILE, 0.075*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuBtn.frame = CGRectMake(4, 0, 44, 44);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.menuBtn];
    
    self.searchDisplayController.searchBar.backgroundColor = [UIColor clearColor];
    self.searchDisplayController.searchBar.tintColor = [UIColor whiteColor];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        UITextView *searchTextField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
        searchTextField.textColor = [UIColor whiteColor];
    }
    
    for (UIView *subview in self.searchDisplayController.searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    [self loadLocations];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
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
    NSDictionary *locationDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    location = [[NSMutableArray alloc] init];
    NSArray *locationArray = (NSArray*)[locationDictionary objectForKey:@"locations"];
    
    for (NSDictionary* dic in locationArray) {
        
        NSNumber * latitude = [dic objectForKey:@"latitude"];
        NSNumber * longitude = [dic objectForKey:@"longitude"];
        NSString * name = [dic objectForKey:@"name"];
        NSString * address = [dic objectForKey:@"address"];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        Location *annotation = [[Location alloc] initWithName:name address:address coordinate:coordinate];
        if([[dic objectForKey:@"type"] isEqualToString:@"building"])
            [self.mapView addAnnotation:annotation];
        [location addObject:annotation];
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"title contains[cd] %@",
                                    searchText];
    
    searchResults = [location filteredArrayUsingPredicate:resultPredicate];
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
