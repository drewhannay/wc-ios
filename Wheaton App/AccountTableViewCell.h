//
//  AmountTableViewCell.h
//  Wheaton App
//
//  Created by Chris Anderson on 4/8/14.
//
//

#import <UIKit/UIKit.h>

@interface AccountTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *deduction;
@property (strong, nonatomic) IBOutlet UILabel *payment;

@end
