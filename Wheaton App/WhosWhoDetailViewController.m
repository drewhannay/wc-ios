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

@synthesize person, name, classification, email, profileImage, bottomBlur, image, blurView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    name.text = [person fullNameWithPref];
    email.text = person.email;
    classification.text = person.classification;
    
    [self setFrameByImage];
    
    blurView = [AMBlurView new];
    [blurView setFrame:CGRectMake(0,
                                  bottomBlur.frame.origin.y-bottomBlur.frame.size.height,
                                  bottomBlur.frame.size.width,
                                  bottomBlur.frame.size.height)];
    [self.view insertSubview:blurView belowSubview:(UIView *)bottomBlur];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (image) {
        profileImage.image = image;
        [self setFrameByImage];
    }
    [super viewWillAppear:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (image) {
        profileImage.image = image;
        [self setFrameByImage];
        NSLog(@"%f", profileImage.frame.origin.y);
    }
    [super viewDidAppear:NO];
    
    NSString *imagename = person.photo;
    if (!image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: imagename]]];
            
            if (image) {
                
                [self setFrameByImage];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    profileImage.image = image;
                });
            }
        });
    } else {
        [self setFrameByImage];
    }
}

- (void)setFrameByImage
{
    if (image) {
        CGSize imgSize = image.size;
        float imageHeight = imgSize.height;
        float imageWidth = imgSize.width;
        
        float ratio = 320 / imageWidth;
        float scaledHeight = imageHeight * ratio;
        
        if(scaledHeight < self.view.frame.size.height) {
            profileImage.frame = CGRectMake(0,
                                            0,
                                            320,
                                            scaledHeight);
        } else {
            profileImage.frame = CGRectMake(0, 0, 320, 300);
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
