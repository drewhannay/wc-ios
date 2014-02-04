//
//  WhosWhoDetailViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 1/9/14.
//
//

#import <UIKit/UIKit.h>
#import "AMBlurView.h"
#import "Person.h"

@interface WhosWhoDetailViewController : UIViewController


@property (strong, nonatomic) Person *person;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *email;
@property (strong, nonatomic) IBOutlet UILabel *classification;
@property (strong, nonatomic) IBOutlet UILabel *cpo;
@property (strong, nonatomic) IBOutlet UIView *bottomBlur;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) AMBlurView *blurView;

- (void)setFrameByImage;

@end
