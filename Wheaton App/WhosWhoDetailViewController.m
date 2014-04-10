//
//  WhosWhoDetailViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 1/9/14.
//
//

#import "WhosWhoDetailViewController.h"
#import "Banner.h"

@interface WhosWhoDetailViewController ()

@end

@implementation WhosWhoDetailViewController {
    UIImageView *imageHolder;
    UIImageView *imageHolderSmall;
}

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
        blurView = [JCRBlurView new];
        [blurView setFrame:CGRectMake(0,
                                      self.view.frame.size.height-190,
                                      320,
                                      100)];
        [self.view insertSubview:blurView belowSubview:(UIView *)bottomBlur];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    if ([Banner hasLoggedIn]) {
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired = 2;
        [self.view addGestureRecognizer:tapGesture];
    
        [self displayWink];
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

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self setFavorite];
        [self displayWink];
    }
}

- (void)displayWink
{
    if (!imageHolderSmall) {
        imageHolderSmall = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
        UIImage *winkImage = [UIImage imageNamed:@"wink"];
        imageHolderSmall.image = winkImage;
        imageHolderSmall.alpha = 0.0;
        [self.view addSubview:imageHolderSmall];
    }
    
    if ([self inFavorites]) {
        imageHolderSmall.alpha = 1.0;
    } else {
        imageHolderSmall.alpha = 0.0;
    }
}

- (void)animateWink
{
    if (!imageHolder) {
        imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-64,
                                                                    self.view.frame.size.height/2-64, 128, 128)];
        UIImage *winkImage = [UIImage imageNamed:@"wink"];
        imageHolder.image = winkImage;
        imageHolder.alpha = 0.0;
        [self.view addSubview:imageHolder];
    }
    
    if ([self inFavorites]) {
        imageHolder.alpha = 1.0;
    }
}

- (void)setFavorite
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorites = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"favorites"]];
    if (!favorites) {
        favorites = [[NSMutableArray alloc] init];
    }

    if ([self inFavorites]) {
        [favorites removeObject:person.uid];
    } else {
        [favorites addObject:person.uid];
    }
    NSLog(@"%@", favorites);
    [prefs setObject:favorites forKey:@"favorites"];
    [prefs synchronize];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"uuid": [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"],
                                 @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                                 @"favorites":favorites
                                 };
    
    [manager POST:c_Favorites parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {}
          failure:^(AFHTTPRequestOperation *operation, NSError *error) { NSLog(@"COULD NOT SAVE"); }];
}

- (BOOL)inFavorites
{
    NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"];
    if (favorites) {
        for (NSString *uid in favorites) {
            if ([uid isEqualToString:person.uid]) {
                return YES;
            }
        }
    }
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
