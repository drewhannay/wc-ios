//
//  SportsTableCell.h
//  Wheaton App
//
//  Created by Chris Anderson on 9/1/13.
//
//

#import <UIKit/UIKit.h>

@interface SportTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *opponent;
@property (strong, nonatomic) IBOutlet UILabel *team;
@property (strong, nonatomic) IBOutlet UILabel *scoreOpponent;
@property (strong, nonatomic) IBOutlet UILabel *scoreSchool;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *sport;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *home;

@end
