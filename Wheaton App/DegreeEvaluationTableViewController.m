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
    
    [Banner getDegree:^(NSArray *degree) {
        self.degree = degree;
        NSLog(@"%@", degree);
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
    return [cr.courses count] + [cr.missing count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseRequirement *cr = [self.degree objectAtIndex:indexPath.section];
    
    NSString *cellIdentifier = @"CourseTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.row < [cr.missing count]) {
        cellIdentifier = @"CourseTableCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    } else {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    
    if (indexPath.row < [cr.missing count]) {
        NSLog(@"NOT THIS HAPPENED");
        NSString *warning = [cr.missing objectAtIndex:indexPath.row];
        cell.textLabel.text = warning;
    } else {
        NSLog(@"THIS HAPPENED");
        Course *c = [cr.courses objectAtIndex:(indexPath.row - [cr.missing count])];
        cell = [c generateCell:(CourseTableCell *)cell];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    CourseRequirement *cr = [self.degree objectAtIndex:sectionIndex];
    return cr.type;
}

@end
