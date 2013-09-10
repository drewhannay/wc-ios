//
//  WhoswhoTableCell.m
//  Wheaton App
//
//  Created by Chris Anderson on 8/26/13.
//
//

#import "WhoswhoTableCell.h"

@implementation WhoswhoTableCell

@synthesize profileImage;
@synthesize name;
@synthesize type;
@synthesize year;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetCell
{
    for (UILabel *label in labels)
        [label removeFromSuperview];
    [labels removeAllObjects];
}

@end
