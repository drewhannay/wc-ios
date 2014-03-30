//
//  CourseTableViewCell.h
//  Wheaton App
//
//  Created by Chris Anderson on 3/28/14.
//
//

#import <UIKit/UIKit.h>

@interface CourseTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *courseLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *creditsLabel;

@end
