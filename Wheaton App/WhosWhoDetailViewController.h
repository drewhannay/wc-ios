//
//  WhosWhoDetailViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 8/29/13.
//
//

#import <UIKit/UIKit.h>

@interface WhosWhoDetailViewController : UIViewController <UINavigationControllerDelegate>
{
    int runningHeight;
    NSMutableArray *labels;
}

@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) NSDictionary *person;

@end
