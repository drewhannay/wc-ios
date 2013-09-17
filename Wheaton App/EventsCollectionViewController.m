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

@synthesize collectionView, schedule;
@synthesize displayResults = _displayResults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"CST"]];
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss z"];
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    schedule = [[NSMutableArray alloc] init];
    [self loadSchedule];
}

- (void)loadSchedule
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString: c_Events]];
        [self performSelectorOnMainThread:@selector(startParser:) withObject:data waitUntilDone:YES];
    });
}

- (void)startParser:(id)responseData
{
    if (responseData == nil) {
        return;
    }
    parser = [[NSXMLParser alloc] initWithData:responseData];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:@"item"]) {
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        date    = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        
        NSString *purifiedString = [date stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        purifiedString = [purifiedString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSDate *entryDate = [dateFormatter dateFromString:purifiedString];
        
        [item setObject:entryDate forKey:@"date"];
        [schedule addObject:[item copy]];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"pubDate"]) {
        [date appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [collectionView reloadData];
}


#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if([schedule count] <= 0) {
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
    
    NSDictionary *row = [schedule objectAtIndex:indexPath.row];
    
    cell.title.text = [row objectForKey:@"title"];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:[row objectForKey:@"date"]];
    
    cell.date.text = [NSString stringWithFormat:@"%d/%d", [components month], [components day]];
    
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
