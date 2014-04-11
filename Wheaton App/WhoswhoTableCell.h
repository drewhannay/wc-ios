//
//  WhoswhoTableCell.h
//  Wheaton App
//
//  Created by Chris Anderson on 8/26/13.
//
//

#import <UIKit/UIKit.h>

@interface WhoswhoTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *firstName;
@property (strong, nonatomic) IBOutlet UILabel *lastName;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *profileImage;

@end
