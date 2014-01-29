//
//  EventTableCell.h
//  Wheaton App
//
//  Created by Chris Anderson on 8/26/13.
//
//

#import <UIKit/UIKit.h>

@interface EventTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *current;


@end
