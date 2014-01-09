//
//  WhosWhoDetailViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 1/9/14.
//
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface WhosWhoDetailViewController : UIViewController

@property (strong, nonatomic) Person *person;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *firstName;
@property (strong, nonatomic) IBOutlet UILabel *lastName;
@property (strong, nonatomic) IBOutlet UILabel *email;

@end
