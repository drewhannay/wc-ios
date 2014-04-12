//
//  HomePastViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 12/14/13.
//
//

#import "HomePastViewController.h"
#import "SportTableCell.h"
#import "EventTableCell.h"
#import "MetraTableViewCell.h"
#import "TEAChart.h"
#import "Banner.h"
#import "Sport.h"

@interface HomePastViewController ()

@property (strong, nonatomic) NSDictionary *chapelSkips;

@end

@implementation HomePastViewController

@synthesize home, scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    home = [[NSMutableArray alloc] init];
    
    NSMutableArray *chapelSection = [[NSMutableArray alloc] init];
    [home addObject:chapelSection];
    
    NSMutableArray *sportSection = [[NSMutableArray alloc] init];
    [home addObject:sportSection];
    
    NSMutableArray *metraSection = [[NSMutableArray alloc] init];
    [home addObject:metraSection];
    
    [scrollView loaded:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [scrollView setDelegate:self];
    [scrollView setScrollEnabled:YES];
    [scrollView setAutoresizingMask:UIViewAutoresizingNone];
    
    [self load];
}

- (void)load
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:c_Home parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        
        [[home objectAtIndex:0] removeAllObjects];
        [[home objectAtIndex:1] removeAllObjects];
        [[home objectAtIndex:2] removeAllObjects];
        
        
        NSArray *chapelArray = [dic objectForKey:@"chapel"];
        if ([chapelArray count] > 0) {
            [[home objectAtIndex:0] addObject:[chapelArray objectAtIndex:0]];
        }
        
        NSArray *sportArray = [dic objectForKey:@"sports"];
        for (NSDictionary *s in sportArray) {
            Sport *sport = [[Sport alloc] init];
            [sport jsonToSport:s];
            [[home objectAtIndex:1] addObject:sport];
            [self.tableView reloadData];
        }
        
        NSArray *metraArray = [dic objectForKey:@"train"];
        for (NSDictionary *m in metraArray) {
            [[home objectAtIndex:2] addObject:m];
        }
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [Banner getChapelSkips:^(NSDictionary *attendance) {
        self.chapelSkips = attendance;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [home count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[home objectAtIndex:section] count];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([Banner hasLoggedIn]) {
        if([view isKindOfClass:[UITableViewHeaderFooterView class]] && section == 0){
            UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake (153, 30, 150, 20)];
            [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
            [label setTextColor:[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0f]];
            [label setTextAlignment:NSTextAlignmentRight];
            int absences = [[self.chapelSkips objectForKey:@"absences"] intValue];
            if (self.chapelSkips) {
                label.text = [[NSString stringWithFormat:@"Skips: %d/11", absences] uppercaseString];
            }
            
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)];
            [label addGestureRecognizer:tapGesture];
            
            [tableViewHeaderFooterView addSubview:label];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Chapel";
    } else if(section == 1) {
        return @"Sports";
    } else {
        return @"Metra";
    }
}

- (void)labelTap {
    NSString *skips = [[[self.chapelSkips objectForKey:@"days"] valueForKey:@"description"] componentsJoinedByString:@"\n"];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Skips:"
                                                      message:skips
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        NSString *cellIdentifier = @"EventCell";
        NSString *cellFileName = @"EventSubtitleLineView";
        
        NSDictionary *row = [[home objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        if ([[row objectForKey:@"description"] isEqualToString:@""]) {
            cellIdentifier = @"EventSingleCell";
            cellFileName = @"EventSingleLineView";
        }
        
        EventTableCell *eventCell = (EventTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (eventCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellFileName owner:nil options:nil];
            eventCell = [nib objectAtIndex:0];
        }
        
        eventCell.titleLabel.text = [row objectForKey:@"title"];
        eventCell.subtitleLabel.text = [row objectForKey:@"description"];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[row objectForKey:@"timeStamp"] objectAtIndex:0] doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [dateFormatter setDateFormat:@"dd"];
        
        
        eventCell.dateLabel.text = [dateFormatter stringFromDate:date];
        
        cell = eventCell;
    } else if (indexPath.section == 1) {
        
        Sport *sport = [[home objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
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
        
        NSString *cellIdentifier = @"MetraCell";
        NSString *cellFileName = @"MetraTableViewCell";
        
        NSDictionary *inbound = [[[home objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"inbound"];
        NSDictionary *outbound = [[[home objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"outbound"];
        
        MetraTableViewCell *eventCell = (MetraTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (eventCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellFileName owner:nil options:nil];
            eventCell = [nib objectAtIndex:0];
        }
        
        eventCell.origin.text = [inbound objectForKey:@"origin"];
        eventCell.destination.text = [inbound objectForKey:@"destination"];
        
        eventCell.departureTimeInbound.text = [inbound objectForKey:@"departure"];
        eventCell.departureTimeOutbound.text = [outbound objectForKey:@"departure"];
        
        cell = eventCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
