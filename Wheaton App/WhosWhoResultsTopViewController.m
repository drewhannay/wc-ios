//
//  WhosWhoResultsTopViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 8/28/13.
//
//

#import "WhosWhoResultsTopViewController.h"
#import "WhoswhoTableCell.h"
#import "WhosWhoDetailViewController.h"
#import "WhosWhoTopViewController.h"

@interface WhosWhoResultsTopViewController ()

@end

@implementation WhosWhoResultsTopViewController

@synthesize searchBox, loadingView, searchResults, resultsList;

- (void)viewDidLoad
{
    [resultsList setHidden:YES];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    WhosWhoTopViewController *c = (WhosWhoTopViewController *)self.parentViewController;
    [c.menuBtn setHidden:NO];
}

- (void)runSearch
{
    searchParameter = [searchBox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    searchParameter = [searchParameter stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
//    if([searchParameter isEqualToString:@""])
//    {
//        [[[iToast makeText:NSLocalizedString(@"Please enter a search term", @"")] setDuration:3000] show];
//        return;
//    }
    
    [loadingView startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",c_Whoswho, searchParameter]]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData
{
    [loadingView stopAnimating];
    
    if (responseData == nil) {
//        [[[iToast makeText:@"You must be connected to the Wheaton College Wifi Network to use this feature"] setDuration:3000] show];
        return;
    }
    
    // parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *results = [json objectForKey:@"search_results"];
    
    if ([results count] > 0) {
        searchResults = results;
        [resultsList setHidden:NO];
        [resultsList reloadData];
    } else {
//        [[[iToast makeText:NSLocalizedString(@"No results", @"")] setDuration:3000] show];
    }
}
#pragma mark UISearchBarDelegate

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    NSLog(@"Did begin");
//}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [resultsList setHidden:YES];
    [self runSearch];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchResults = nil;
    [resultsList reloadData];
    [searchBar resignFirstResponder];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *cellIdentifier = @"WhoswhoTableCell";
    
    WhoswhoTableCell *cell = (WhoswhoTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WhoswhoTableCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell resetCell];
    
    NSDictionary *result = [searchResults objectAtIndex:indexPath.row];
    
    NSString *firstName = [result objectForKey:@"FirstName"];
//    NSString *prefFirstName = [result objectForKey:@"PrefFirstName"];
    NSString *middleName = [result objectForKey:@"MiddleName"];
    NSString *lastName = [result objectForKey:@"LastName"];
    
    NSMutableString *fullName = [[NSMutableString alloc] initWithString:firstName];
//    if (![self isNullOrEmpty:prefFirstName])
//        [fullName appendFormat:@" \"%@\"", prefFirstName];
    if (![self isNullOrEmpty:middleName])
        [fullName appendFormat:@" %@", middleName];
    if (![self isNullOrEmpty:lastName])
        [fullName appendFormat:@" %@", lastName];
    
    cell.name.text = fullName;
    
//    NSString *cpo = [result objectForKey:@"CPOBox"];
//    if (![self isNullOrEmpty:cpo])
//        [cell addLabelWithString:[NSString stringWithFormat:@"CPO %@", cpo]];
    
    if ([[result objectForKey:@"Type"] isEqualToString:@"1"])
        cell.type.text = @"Faculty/Staff";
    else
        cell.type.text =  @"Student";
    
    NSString *classification = [result objectForKey:@"Classification"];
    if (![self isNullOrEmpty:classification])
        cell.year.text = classification;
    else
        cell.year.text = @"";
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSString *imagename = [result objectForKey:@"PhotoUrl"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: imagename]]];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.profileImage.image = image;
            });
        }
    });
    
    return cell;
}

- (BOOL)isNullOrEmpty:(NSString *) string
{
    return [string isEqual:[NSNull null]] || [string isEqualToString:@""];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake (10, 2, 200, 20)];
    label.text = sectionTitle;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [headerView addSubview:label];
    
    [headerView setBackgroundColor:[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0f]];
    [label setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Results";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{  
    WhosWhoDetailViewController *detailController = [segue destinationViewController];
    WhosWhoTopViewController *c = (WhosWhoTopViewController *)self.parentViewController;
    [c.menuBtn setHidden:YES];
    detailController.person = [searchResults objectAtIndex:resultsList.indexPathForSelectedRow.row];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
