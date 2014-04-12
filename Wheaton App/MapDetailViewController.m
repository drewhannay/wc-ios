//
//  MapDetailViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 2/9/14.
//
//

#import "MapDetailViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AutoTableViewCell.h"

@interface MapDetailViewController ()

@end

@implementation MapDetailViewController

static NSString *cellIdentifier = @"AutoTableViewCell";

@synthesize name, buildingImage, blurView, bottomBlur, building, detailView, buildingTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:building.image]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    
    [self.buildingImage setImageWithURLRequest:request
                              placeholderImage:[UIImage imageNamed:@"building-default"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           buildingImage.image = image;
                                       }
                                       failure:nil];
    
    @try {
        blurView = [JCRBlurView new];
        [blurView setFrame:CGRectMake(0,
                                      bottomBlur.frame.origin.y,
                                      bottomBlur.frame.size.width,
                                      50)];
        blurView.alpha = 0.95;
        [self.detailView insertSubview:blurView belowSubview:bottomBlur];
        [self.view bringSubviewToFront:name];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    self.name.text = building.title;
    
    buildingTable = [[NSMutableArray alloc] init];
    
    NSMutableArray *descriptionSection = [[NSMutableArray alloc] init];
    
    if (!(building.description == (id)[NSNull null] || building.description.length == 0)) {
        [descriptionSection addObject:building.description];
        [buildingTable addObject:descriptionSection];
    }
    
    NSMutableArray *hoursSection = [[NSMutableArray alloc] init];
    
    if (![building.hours isEqual:[NSNull null]] && [building.hours count] > 0) {
        for (NSDictionary *block in building.hours) {
            for (NSString *key in [block allKeys]) {
                NSString *day = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];
                [hoursSection addObject:[NSString stringWithFormat:@"%@: %@", day, [[block objectForKey:key] componentsJoinedByString:@", "]]];
            }
        }
        [buildingTable addObject:hoursSection];
    }
    
    [self.tableView registerClass:[AutoTableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [buildingTable count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[buildingTable objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    if (sectionIndex == 0) {
        return @"About";
    } else if(sectionIndex == 1) {
        return @"Hours";
    } else {
        return @"Other";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AutoTableViewCell *cell = (AutoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell updateFonts];
    
    cell.bodyLabel.text = (NSString *)[[buildingTable objectAtIndex: indexPath.section] objectAtIndex:indexPath.row];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}


- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AutoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell for this indexPath
    [cell updateFonts];
    cell.bodyLabel.text = (NSString *)[[buildingTable objectAtIndex: indexPath.section] objectAtIndex:indexPath.row];
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    // Set the width of the cell to match the width of the table view. This is important so that we'll get the
    // correct height for different table view widths, since our cell's height depends on its width due to
    // the multi-line UILabel word wrapping. Don't need to do this above in -[tableView:cellForRowAtIndexPath]
    // because it happens automatically when the cell is used in the table view.
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
    // in the UITableViewCell subclass
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    height += 1;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500.0f;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
