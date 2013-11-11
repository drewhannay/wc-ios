//
//  SportsTableViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/10/13.
//
//

#import "SportsTableViewController.h"
#import "SportsCollectionCell.h"

@interface SportsTableViewController ()

@end

@implementation SportsTableViewController

@synthesize tableView, sportResults;
@synthesize displayResults = _displayResults;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: cn_Sports]];
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
            [components setMonth: [[[event objectForKey:@"date"] objectForKey:@"month"] intValue]];
            [components setDay: [[[event objectForKey:@"date"] objectForKey:@"day"] intValue]];
            
            NSDate *combinedDate = [calendar dateFromComponents:components];
            
            if([combinedDate timeIntervalSince1970] > [currentDate timeIntervalSince1970]) {
                [sportResults addObject:event];
            }
        }
        [tableView reloadData];
    } else {
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SportTableCell";
    SportsCollectionCell *cell = (SportsCollectionCell *)[tv dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *result = [sportResults objectAtIndex:indexPath.row];
    
    NSDictionary *date = [result objectForKey:@"date"];
    cell.date.text = [NSString stringWithFormat:@"%@/%@", [date objectForKey:@"month"], [date objectForKey:@"day"]];
    cell.time.text = [result objectForKey:@"time"];
    
    NSString *sport = (NSString *)[result objectForKey:@"sport"];
    
    if([sport isEqualToString:@"soccer"])
        cell.sport.image = [UIImage imageNamed:@"Soccer.png"];
    else if([sport isEqualToString:@"basketball"])
        cell.sport.image = [UIImage imageNamed:@"Basketball.png"];
    else if([sport isEqualToString:@"volleyball"])
        cell.sport.image = [UIImage imageNamed:@"Volleyball.png"];
    else if([sport isEqualToString:@"golf"])
        cell.sport.image = [UIImage imageNamed:@"Golf.png"];
    else if([sport isEqualToString:@"football"])
        cell.sport.image = [UIImage imageNamed:@"Football.png"];
    else if([sport isEqualToString:@"tennis"])
        cell.sport.image = [UIImage imageNamed:@"Tennis.png"];
    
    cell.team.text = [NSString stringWithFormat:@"%@. %@", [[[result objectForKey:@"gender"] substringToIndex:1] uppercaseString], [[result objectForKey:@"sport"] capitalizedString]];
    cell.opponent.text = [result objectForKey:@"opponent"];
    
    if([(NSNumber *)[result objectForKey: @"home"] isEqual: @(YES)]) {
        [cell.home setHidden:FALSE];
    } else {
        [cell.home setHidden:TRUE];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
