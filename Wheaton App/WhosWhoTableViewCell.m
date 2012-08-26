//
//  WhosWhoTableViewCell.m
//  Wheaton App
//
//  Created by Drew Hannay on 8/24/12.
//
//

#import "WhosWhoTableViewCell.h"

@implementation WhosWhoTableViewCell

@synthesize profileImage;
@synthesize labelView;

-(void)addLabelWithString:(NSString *)labelText
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, runningHeight, 175, 20)];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.text = labelText;

    CGSize maximumLabelSize = CGSizeMake(175, MAXFLOAT);
    CGSize expectedLabelSize = [labelText sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];

    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;

    runningHeight += label.frame.size.height + 5;

    if ([labels count] == 0)
        labels = [[NSMutableArray alloc] initWithCapacity:4];

    [labels addObject:label];

    [labelView addSubview:label];
}

-(void)resetCell
{
    for (UILabel *label in labels)
        [label removeFromSuperview];
    [labels removeAllObjects];
    runningHeight = 0;
}

@end
