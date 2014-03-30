//
//  WhosWhoDetailViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 1/9/14.
//
//

#import "WhosWhoDetailViewController.h"

@interface WhosWhoDetailViewController ()

@end

@implementation WhosWhoDetailViewController

@synthesize person, name, classification, email, cpo, profileImage, bottomBlur, image, blurView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    name.text = [person fullNameWithPref];
    email.text = person.email;
    classification.text = person.classification;
    cpo.text = [NSString stringWithFormat:@"CPO: %@", person.cpo];
    
    profileImage.contentMode = UIViewContentModeTop;

    @try {
        blurView = [AMBlurView new];
        [blurView setFrame:CGRectMake(0,
                                      self.view.frame.size.height-190,
                                      320,
                                      100)];
        [self.view insertSubview:blurView belowSubview:(UIView *)bottomBlur];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Whos Who" properties:@{ @"query": person.fullName }];
    
    NSString *imagename = person.photo;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: imagename]]];
        if (self.view.frame.size.height < 400) {
            image = [image scaleToWidth:320.0 constraint:self.view.frame.size.height-50];
        } else {
            image = [image scaleToWidth:320.0 constraint:self.view.frame.size.height];
        }
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                profileImage.image = image;
            });
        }
    });
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
