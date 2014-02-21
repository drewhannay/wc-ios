//
//  BannerLoginViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 2/19/14.
//
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AFNetworking.h"

@interface BannerLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
