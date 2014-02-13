//
//  MapDetailViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 2/9/14.
//
//

#import "MapDetailViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface MapDetailViewController ()

@end

@implementation MapDetailViewController

@synthesize name, buildingImage, buildingImageBlur, blurView, bottomBlur, building;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.name.text = building.title;
    self.description.text = building.description;
    [self.description setNumberOfLines:0];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:building.image]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    
    [self.buildingImage setImageWithURLRequest:request
                             placeholderImage:[UIImage imageNamed:@"default-image"]
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          buildingImage.image = image;
                                          buildingImageBlur.image = image;
                                      }
                                      failure:nil];
    
    @try {
        blurView = [AMBlurView new];
        [blurView setFrame:CGRectMake(0,
                                      bottomBlur.frame.origin.y-self.navigationController.navigationBar.frame.size.height+14,
                                      bottomBlur.frame.size.width,
                                      50)];
        [self.view insertSubview:blurView belowSubview:(UIView *)bottomBlur];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
