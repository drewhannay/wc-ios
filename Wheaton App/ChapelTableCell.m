//
//  ChapelTableCell.m
//  Wheaton App
//
//  Created by Chris Anderson on 8/26/13.
//
//

#import "ChapelTableCell.h"

@implementation ChapelTableCell

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize subtitleLabel = _subtitleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
