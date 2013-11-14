//
//  HomeSportsCollectionViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 9/1/13.
//
//

#import "HomeSportsCollectionViewController.h"
#import "SportsCollectionCell.h"
#import "MenuTopViewController.h"

@interface HomeSportsCollectionViewController ()

@end

@implementation HomeSportsCollectionViewController

@synthesize collectionView, sportResults;
@synthesize displayResults = _displayResults;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: c_Sports]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData
{
    if (responseData == nil) {
        return;
    }
    
    // parse out the json data
    NSError *error;
    sportResults  = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    [collectionView reloadData];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if([sportResults count] <= 0) {
        return 0;
    }
    if(self.displayResults <= 0) {
        return [sportResults count];
    }
    if(self.displayResults > [sportResults count])
        return [sportResults count];
    return self.displayResults;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SportsCollectionCell *cell = (SportsCollectionCell *)[cv dequeueReusableCellWithReuseIdentifier:@"SportsCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *result = [sportResults objectAtIndex:indexPath.row];
    NSDictionary *custom = [result objectForKey:@"custom"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[result objectForKey:@"timeStamp"] objectAtIndex:0] doubleValue]];
    NSString *sport = (NSString *)[result objectForKey:@"title"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"MM/dd hh:mm a"];
    
    cell.time.text = [[dateFormatter stringFromDate:date] lowercaseString];
    
    [cell.sport setHidden:NO];
    if([sport isEqualToString:@"Soccer"])
        cell.sport.image = [UIImage imageNamed:@"Soccer.png"];
    else if([sport isEqualToString:@"Basketball"])
        cell.sport.image = [UIImage imageNamed:@"Basketball.png"];
    else if([sport isEqualToString:@"Volleyball"])
        cell.sport.image = [UIImage imageNamed:@"Volleyball.png"];
    else if([sport isEqualToString:@"Golf"])
        cell.sport.image = [UIImage imageNamed:@"Golf.png"];
    else if([sport isEqualToString:@"Football"])
        cell.sport.image = [UIImage imageNamed:@"Football.png"];
    else if([sport isEqualToString:@"Tennis"])
        cell.sport.image = [UIImage imageNamed:@"Tennis.png"];
    else if([sport isEqualToString:@"Swimming"])
        cell.sport.image = [UIImage imageNamed:@"Swimming.png"];
    else
        [cell.sport setHidden:YES];
    
    cell.team.text = [NSString stringWithFormat:@"%@. %@", [[[custom objectForKey:@"gender"] substringToIndex:1] uppercaseString], [sport capitalizedString]];
    cell.opponent.text = [custom objectForKey:@"opponent"];
    
    if([(NSNumber *)[custom objectForKey: @"home"] isEqual: @(YES)]) {
        [cell.home setHidden:FALSE];
    } else {
        [cell.home setHidden:TRUE];
    }
    
    return cell; 
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
