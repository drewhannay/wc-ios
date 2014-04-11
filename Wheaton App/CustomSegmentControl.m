//
//  CustomSegmentControl.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/10/13.
//
//

#import "CustomSegmentControl.h"

@implementation CustomSegmentControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setBorder:(CGContextRef)context withRect:(CGRect)rect usingColor:(CGColorRef)color
{
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGColorRef borderBottomColor = CGColorRetain([UIColorFromRGB(0x7e8083) CGColor]);
    CGColorRef dividerColor = CGColorRetain([UIColorFromRGB(0xDADDE0) CGColor]);
    CGColorRef backgroundColor = CGColorRetain([UIColorFromRGB(0xE1E4E7) CGColor]);
    
    CGContextRef context;

    rect.size.height = 39;
    
    UIGraphicsBeginImageContext(rect.size);
    context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, backgroundColor);
    CGColorRelease(backgroundColor);
    CGContextFillRect(context, rect);
    [self setBorder:context withRect:rect usingColor:dividerColor];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(rect.size);
    context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, dividerColor);
    CGContextFillRect(context, rect);
    [self setBorder:context withRect:rect usingColor:borderBottomColor];
    CGColorRelease(borderBottomColor);
    UIImage *backgroundHighlightedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect divider = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(divider.size);
    context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, dividerColor);
    CGColorRelease(dividerColor);
    CGContextFillRect(context, rect);
    UIImage *dividerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:13], NSFontAttributeName,
                                [UIColor blackColor], NSForegroundColorAttributeName,
                                nil];
    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [self setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [self setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:backgroundHighlightedImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:backgroundHighlightedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [self setDividerImage:dividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

}


@end
