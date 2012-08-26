//
//  WhosWhoTableViewCell.h
//  Wheaton App
//
//  Created by Drew Hannay on 8/24/12.
//
//

#import <UIKit/UIKit.h>

@interface WhosWhoTableViewCell : UITableViewCell
{
    int runningHeight;
    NSMutableArray *labels;
}

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *profileImage;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *labelView;

-(void)addLabelWithString:(NSString *)labelText;
-(void)resetCell;

@end
