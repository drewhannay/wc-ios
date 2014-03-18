//
//  DegreeEvaluationTableViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 3/18/14.
//
//

#import "DegreeEvaluationTableViewController.h"
#import "Banner.h"
#import "CourseRequirement.h"
#import "Course.h"

@interface DegreeEvaluationTableViewController ()

@end

@implementation DegreeEvaluationTableViewController

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
    
    [Banner getDegree:^(NSArray *attendance) {
        self.degree = attendance;        
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
    // Return the number of sections.
    return [self.degree count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CourseRequirement *cr = [self.degree objectAtIndex:section];
    return [cr.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CourseRequirement *cr = [self.degree objectAtIndex:indexPath.section];
    Course *c = [cr.courses objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", c.number, c.name];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    CourseRequirement *cr = [self.degree objectAtIndex:sectionIndex];
    return cr.type;
}

@end
