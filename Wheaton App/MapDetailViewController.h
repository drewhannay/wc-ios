//
//  MapDetailViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 2/9/14.
//
//

#import <UIKit/UIKit.h>
#import "AMBlurView.h"
#import "Location.h"

@interface MapDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *description;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *buildingImage;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *buildingImageBlur;
@property (strong, nonatomic) IBOutlet UIView *bottomBlur;
@property (strong, nonatomic) AMBlurView *blurView;

@property (strong, nonatomic) Location *building;

@end
