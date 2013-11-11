//
//  MasterTabViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/7/13.
//
//

#import "MasterTabViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


NSString * const cn_MapLocations = @"https://s3.amazonaws.com/wcstatic/location.json";
NSString * const cn_Chapel = @"https://s3.amazonaws.com/wcstatic/chapel.json";
NSString * const cn_Menu = @"http://wheatonorientation.herokuapp.com/menu";
NSString * const cn_Whoswho = @"https://webapp.wheaton.edu/whoswho/person/searchJson?page_size=100&q=2%20";
NSString * const cn_Sports = @"https://s3.amazonaws.com/wcstatic/sports_calendar.json";
NSString * const cn_Academic = @"http://25livepub.collegenet.com/calendars/event-collections-general_calendar_wp.rss";
NSString * const cn_Banners = @"https://s3.amazonaws.com/wcstatic/banners.json";
NSString * const cn_Events = @"http://25livepub.collegenet.com/calendars/intra-campus-calendar.rss";

@interface MasterTabViewController ()

@end

@implementation MasterTabViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [[UITabBar appearance] setTintColor:UIColorFromRGB(0x0069aa)];
    self.delegate = self;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
