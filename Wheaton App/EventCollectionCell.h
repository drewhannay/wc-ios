//
//  EventCollectionCell.h
//  Wheaton App
//
//  Created by Chris Anderson on 9/1/13.
//
//

#import <UIKit/UIKit.h>

@interface EventCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *title;

@end
