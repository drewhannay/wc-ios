//
//  SportsCollectionCell.h
//  Wheaton App
//
//  Created by Chris Anderson on 9/1/13.
//
//

#import <UIKit/UIKit.h>

@interface SportsCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *opponent;
@property (strong, nonatomic) IBOutlet UILabel *team;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *sport;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *home;

@end
