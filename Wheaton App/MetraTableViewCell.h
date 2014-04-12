//
//  MetraTableViewCell.h
//  Wheaton App
//
//  Created by Chris Anderson on 2/21/14.
//
//

#import <UIKit/UIKit.h>

@interface MetraTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *origin;
@property (weak, nonatomic) IBOutlet UILabel *destination;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeInbound;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeInbound;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeOutbound;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeOutbound;

@end
