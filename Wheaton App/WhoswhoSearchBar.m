//
//  WhoswhoSearchBar.m
//  Wheaton App
//
//  Created by Chris Anderson on 8/28/13.
//
//

#import "WhoswhoSearchBar.h"

CGFloat ViewHeight = 44;
CGFloat ViewMargin = 0;
CGFloat TextfieldLeftMargin = 0;

CGFloat CancelAnimationDistance = 80;

@interface WhoswhoSearchBar ()

@end

@implementation WhoswhoSearchBar
{
    UITextField *foundSearchTextField;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor blackColor];
    self.showsScopeBar = NO;
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
}

- (void)layoutSubviews
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
        UITextField *searchField;
        NSUInteger numViews = [self.subviews count];
        for(int i = 0; i < numViews; i++) {
            if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
                searchField = [self.subviews objectAtIndex:i];
            }
        }
        if(!(searchField == nil)) {
            searchField.textColor = [UIColor blackColor];
            [searchField setBackgroundColor: [UIColor whiteColor]];
            [searchField setBackground: nil];
            [searchField setPlaceholder: @"Search"];
            [searchField setBorderStyle:UITextBorderStyleNone];
        }
    }
    [super layoutSubviews];
}
    
@end
