//
//  HomePastViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 12/14/13.
//
//

#import "HomePastViewController.h"
#import "MasterTabViewController.h"
#import "SportTableCell.h"
#import "EventTableCell.h"
#import "Sport.h"

@interface HomePastViewController ()

@end

@implementation HomePastViewController

@synthesize past;

- (void)viewDidLoad
{
    [super viewDidLoad];
    past = [[NSMutableArray alloc] init];
    [self loadTable];
}

- (void)loadTable
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: c_Home]];
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
    NSDictionary *pastJson = [[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error] objectForKey:@"present"];
    
    NSArray *chapelSection = [pastJson objectForKey:@"chapel"];
    [past addObject:chapelSection];
    
    NSArray *sportSection = [pastJson objectForKey:@"sports"];
    NSMutableArray *sports = [[NSMutableArray alloc] init];
    
    for (NSDictionary *s in sportSection) {
        Sport *sport = [[Sport alloc] init];
        [sport jsonToSport:s];
        [sports addObject: sport];
    }
    [past addObject:sports];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [past count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"%lu", (unsigned long)[[past objectAtIndex:section] count]);
    return [[past objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    if (sectionIndex == 0) {
        return @"Chapel";
    } else if(sectionIndex == 1) {
        return @"Sports";
    } else {
        return @"Events";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        NSString *cellIdentifier = @"EventCell";
        NSString *cellFileName = @"EventSubtitleLineView";
        
        NSDictionary *row = [[past objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        if([[row objectForKey:@"subtitle"] isEqualToString:@""]) {
            cellIdentifier = @"EventSingleCell";
            cellFileName = @"EventSingleLineView";
        }
        
        EventTableCell *eventCell = (EventTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (eventCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellFileName owner:nil options:nil];
            eventCell = [nib objectAtIndex:0];
        }
        
        eventCell.titleLabel.text = [row objectForKey:@"title"];
        eventCell.subtitleLabel.text = [row objectForKey:@"subtitle"];
        eventCell.dateLabel.text = [NSString stringWithFormat:@"%@", [row objectForKey:@"date"]];
        
        cell = eventCell;
    } else if (indexPath.section == 1) {
    
        Sport *sport = [[past objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        NSString *cellIdentifier = @"SportTableCell";
        
        if ([sport.score count] > 0 && ![[sport.score objectForKey:@"school"] isEqual: @""]) {
            cellIdentifier = @"SportScoreTableCell";
        }
        
        SportTableCell *sportCell = (SportTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (sportCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            sportCell = [nib objectAtIndex:0];
        }
        
        cell = [sport generateCell:sportCell];
    } else if (indexPath.section == 2) {
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
