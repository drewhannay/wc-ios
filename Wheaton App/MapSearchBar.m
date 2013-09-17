//
//  MapSearchBar.m
//  Wheaton App
//
//  Created by Chris Anderson on 9/10/13.
//
//

#import "MapSearchBar.h"

@implementation MapSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) addSubview:(UIView *)view {
    [super addSubview:view];
    
    if ([view isKindOfClass:UIButton.class]) {
        UIButton *cancelButton = (UIButton *)view;
        
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateHighlighted];
    }
}

@end
