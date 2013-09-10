//
//  SideBarTableCell.m
//  Wheaton App
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import "SideBarTableCell.h"

@implementation SideBarTableCell

@synthesize itemLabel = _itemLabel;

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
    
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorRef bottomColor = CGColorRetain([UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f].CGColor);
    
    CGContextSetStrokeColorWithColor(ctx, bottomColor);
    CGContextMoveToPoint(ctx, 0, rect.size.height);
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
    CGContextStrokePath(ctx);

}

@end
