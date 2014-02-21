//
//  BannerLoginViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 2/19/14.
//
//

#import "BannerLoginViewController.h"
#import "Banner.h"

@interface BannerLoginViewController ()

@end

@implementation BannerLoginViewController

@synthesize email, password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (email.text.length <= 0 && password.text.length <= 0) {
        return NO;
    }
    
    NSDictionary *user = @{
                           @"email": email.text,
                           @"password": password.text,
                           @"uuid": [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"],
                           @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] };
    
    [Banner setUser:user success:^(NSDictionary *response) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Response:"
                                                          message:[NSString stringWithFormat:@"%@", response]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        [self resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error:"
                                                          message:[NSString stringWithFormat:@"%@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }];
    
    return YES;
}

@end
