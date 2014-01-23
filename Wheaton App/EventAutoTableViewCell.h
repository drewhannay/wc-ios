//
//  EventAutoTableViewCell.h
//  Wheaton App
//
//  Created by Chris Anderson on 1/21/14.
//
//

#import <UIKit/UIKit.h>
#import "UIView+AutoLayout.h"

@interface EventAutoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel;

- (void)updateFonts;

@end
