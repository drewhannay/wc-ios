//
//  HomeSearchDisplayController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/12/13.
//
//

#import "HomeSearchDisplayController.h"
#import "MasterTabViewController.h"
#import "Person.h"

@implementation HomeSearchDisplayController

@synthesize people;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [(Person *)[people objectAtIndex:indexPath.row] fullName]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SELECTED");
}

- (void)makeSearch:(NSString *)filter
{
    NSString *searchParameter = [filter stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    searchParameter = [searchParameter stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    if([searchParameter isEqualToString:@""]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",c_Whoswho, searchParameter]]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}


- (void)fetchedData:(id)responseData
{
    if (responseData == nil) {
        return;
    }
    NSError* error;
    NSArray *resultsArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    people = [[NSMutableArray alloc] init];
    
    for (NSDictionary* dic in resultsArray) {
        
        Person *person = [[Person alloc] init];
        
        NSDictionary *name = [dic objectForKey:@"name"];
        
        person.firstName = [name objectForKey:@"first"];
        person.lastName = [name objectForKey:@"last"];
        person.email = [dic objectForKey:@"email"];
        
        NSLog(@"%@", [name objectForKey:@"last"]);
        
        [people addObject:person];
    }
    
    [self.searchResultsTableView reloadData];
}

#pragma mark - UISearchDisplayController delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self makeSearch:searchString];
    
    return YES;
}

@end
