//
//  EventsCollectionViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 9/1/13.
//
//

#import "EventsCollectionViewController.h"
#import "EventCollectionCell.h"
#import "MenuTopViewController.h"

@interface EventsCollectionViewController ()

@end

@implementation EventsCollectionViewController

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
    NSArray *results  = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    
    sportResults = [[NSMutableArray alloc] init];
    
    if ([results count] > 0) {
        for(NSDictionary *event in results) {
            if([[[event objectForKey:@"date"] objectForKey:@"month"] intValue] >=  [components month]) {
                if([[[event objectForKey:@"date"] objectForKey:@"day"] intValue] >= [components day]) {
                    [sportResults addObject:event];
                }
            }
        }
        [collectionView reloadData];
    } else {
        //        [[[iToast makeText:NSLocalizedString(@"No results", @"")] setDuration:3000] show];
    }
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if([sportResults count] <= 0) {
        return 0;
    }
    return 6;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EventCollectionCell *cell = (EventCollectionCell *)[cv dequeueReusableCellWithReuseIdentifier:@"EventCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *result = [sportResults objectAtIndex:indexPath.row];
    
    NSDictionary *date = [result objectForKey:@"date"];
    cell.date.text = [NSString stringWithFormat:@"%@/%@", [date objectForKey:@"month"], [date objectForKey:@"day"]];
    cell.title.text = [result objectForKey:@"opponent"];
    
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
