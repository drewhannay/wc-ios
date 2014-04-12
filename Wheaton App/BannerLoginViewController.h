//
//  BannerLoginViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 2/19/14.
//
//

#import <UIKit/UIKit.h>

@interface BannerLoginViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
