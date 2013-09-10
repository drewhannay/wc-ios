//
//  WhosWhoDetailViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 8/29/13.
//
//

#import "WhosWhoDetailViewController.h"
#import "WhosWhoTopViewController.h"

@interface WhosWhoDetailViewController ()

@end

@implementation WhosWhoDetailViewController

@synthesize infoView, profileImage;
@synthesize person = _person;

-(void)viewWillAppear:(BOOL)animated
{
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:[UIImageView ...]];
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8, 10, 34, 24); 
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    [self.navigationItem setLeftBarButtonItem:anotherButton];
}

-(void)viewDidLoad
{
//    
//    UINavigationController *navControl = (UINavigationController *)self.window.rootViewController;
//    
//    navControl.
    
    
    NSString *firstName = [self.person objectForKey:@"FirstName"];
    NSString *prefFirstName = [self.person objectForKey:@"PrefFirstName"];
    NSString *middleName = [self.person objectForKey:@"MiddleName"];
    NSString *lastName = [self.person objectForKey:@"LastName"];
    
    NSMutableString *fullName = [[NSMutableString alloc] initWithString:firstName];
    if (![self isNullOrEmpty:prefFirstName])
        [fullName appendFormat:@" \"%@\"", prefFirstName];
    if (![self isNullOrEmpty:middleName])
        [fullName appendFormat:@" %@", middleName];
    if (![self isNullOrEmpty:lastName])
        [fullName appendFormat:@" %@", lastName];
    
    [self addLabelWithString:fullName];
    
    NSString *email = [self.person objectForKey:@"Email"];
    if (![self isNullOrEmpty:email])
        [self addLabelWithString:email];
    
    NSString *cpo = [self.person objectForKey:@"CPOBox"];
    if (![self isNullOrEmpty:cpo])
        [self addLabelWithString:[NSString stringWithFormat:@"CPO %@", cpo]];
    
    if ([[self.person objectForKey:@"Type"] isEqualToString:@"1"])
        [self addLabelWithString:@"Faculty/Staff"];
    else
        [self addLabelWithString:@"Student"];
    
    NSString *classification = [self.person objectForKey:@"Classification"];
    if (![self isNullOrEmpty:classification])
        [self addLabelWithString:classification];
    
    NSString *department = [self.person objectForKey:@"Dept"];
    if (![self isNullOrEmpty:department])
        [self addLabelWithString:department];
    
    NSString *imagename = [self.person objectForKey:@"PhotoUrl"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: imagename]]];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                profileImage.image = image;
            });
        }
    });
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(BOOL)isNullOrEmpty:(NSString *) string
{
    return [string isEqual:[NSNull null]] || [string isEqualToString:@""];
}

-(void)addLabelWithString:(NSString *)labelText
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, runningHeight, 240, 20)];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.text = labelText;
    
    CGSize maximumLabelSize = CGSizeMake(240, MAXFLOAT);
    CGSize expectedLabelSize = [labelText sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
    
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
    
    runningHeight += label.frame.size.height + 2;
    
    if ([labels count] == 0)
        labels = [[NSMutableArray alloc] initWithCapacity:4];
    
    [labels addObject:label];
    
    [infoView addSubview:label];
}

-(void)goBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
