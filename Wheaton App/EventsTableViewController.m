//
//  EventsTableViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/13/13.
//
//

#import "EventsTableViewController.h"
#import "MasterTabViewController.h"
#import "WebViewController.h"

@interface EventsTableViewController ()

@end

@implementation EventsTableViewController

@synthesize eventResults;
@synthesize displayResults = _displayResults;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadCalendar];
}

- (void)loadCalendar
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: c_Events]];
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
    eventResults  = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([eventResults count] <= 0) {
        return 0;
    }
    if(self.displayResults <= 0) {
        return [eventResults count];
    }
    if(self.displayResults > [eventResults count])
        return [eventResults count];
    return self.displayResults;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary *result = [eventResults objectAtIndex:indexPath.row];
    
    NSLog(@"%@", result);
    
    // Configure the cell...
    
    cell.textLabel.text = [result objectForKey:@"title"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"EventDetailView" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebViewController *detailViewController = [segue destinationViewController];
    NSIndexPath *indexPath = sender;
    detailViewController.urlString = [[[eventResults objectAtIndex:indexPath.row] objectForKey:@"custom"] objectForKey:@"link"];

}



@end
