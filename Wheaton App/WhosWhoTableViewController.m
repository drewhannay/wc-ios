//
//  WhosWhoTableViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 12/6/13.
//
//

#import "WhosWhoTableViewController.h"
#import "MasterTabViewController.h"
#import "WhoswhoTableCell.h"
#import "Person.h"

@interface WhosWhoTableViewController ()

@end

@implementation WhosWhoTableViewController

@synthesize people, searchController, searchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"WhoswhoTableCell";
    WhoswhoTableCell *cell = (WhoswhoTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Person *person = (Person *)[people objectAtIndex:indexPath.row];
    
    cell.firstName.text = [NSString stringWithFormat:@"%@", [person fullName]];
    
    NSString *imagename = person.photo;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // presentViewController::animated:completion is always full screen (see problem below)
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
        
        NSLog(@"%@", dic);
        
        person.firstName = [name objectForKey:@"first"];
        person.lastName = [name objectForKey:@"last"];
        person.email = [dic objectForKey:@"email"];
        person.photo = [[[dic objectForKey:@"image"] objectForKey:@"url"] objectForKey:@"medium"];
        
        NSLog(@"%@", [[[dic objectForKey:@"image"] objectForKey:@"url"] objectForKey:@"medium"]);
        
        [people addObject:person];
    }
    [self.tableView reloadData];
}

#pragma mark - UISearchDisplayController delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"THIS");
    [self makeSearch:searchString];
    NSLog(@"THIS");
    
    return YES;
}

@end
