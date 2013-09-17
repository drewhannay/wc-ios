//
//  HomeTopViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 3/28/13.
//
//

#import "HomeTopViewController.h"

@implementation HomeTopViewController

@synthesize menuBtn, scrollView, sportsLabel, happeningLabel, sportsVC;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.layer.shadowOpacity = 0.65f;
    self.view.layer.shadowRadius = 7.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    self.slidingViewController.underRightViewController = NULL;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addBorder:self.sportsLabel];
    [self addBorder:self.happeningLabel];
    
    [scrollView setDelegate:self];
    [scrollView setScrollEnabled:YES];
    [scrollView setAutoresizingMask:UIViewAutoresizingNone];
    [scrollView setContentSize:(CGSizeMake(320, [self determineScrollHeight]))];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuBtn.frame = CGRectMake(4, 0, 44, 44);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.menuBtn];
    
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(self.view.frame.size.width-44-4, 0, 44, 44);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(tweet:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.menuBtn];
    
    [scrollView loaded];
}

- (void)viewDidLayoutSubviews
{
    [scrollView setScrollEnabled:YES];
//    Returns wrong amount. For now will just be using set amount.
//    scrollView.contentSize = CGSizeMake(320, [self determineScrollHeight]);
    scrollView.contentSize = CGSizeMake(320, 830);
}

- (float)determineScrollHeight {
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in scrollView.subviews) {
        scrollViewHeight += view.frame.size.height;
    }
    return scrollViewHeight;
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)tweet:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"#wheatoncollege"];
        [self presentViewController: tweetSheet animated: YES completion: nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now. Please sign in to Twitter in your settings."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EmbededSports"]) {
        self.sportsVC = segue.destinationViewController;
        self.sportsVC.displayResults = 4;
    }
}

- (void)addBorder:(UILabel *)lbl {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, lbl.layer.frame.size.height-1, lbl.layer.frame.size.width, 1);
    [bottomBorder setBorderColor:[UIColor blackColor].CGColor];
    [lbl.layer addSublayer:bottomBorder];
    
}

- (void)viewDidUnload {
    [self setTweetSend:nil];
    [super viewDidUnload];
}
@end