//
//  ChapelTableCell.h
//  Wheaton App
//
//  Created by Chris Anderson on 8/26/13.
//
//

#import <UIKit/UIKit.h>

@interface ChapelTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;


@end
