//
//  HomeScrollViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/14/13.
//
//

#import "HomeScrollViewController.h"

@interface HomeScrollViewController ()

@end

@implementation HomeScrollViewController

@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{

    scrollView.contentSize = CGSizeMake(320, 800);

   // NSLog(@"TEST SCROLLL");
    //NSLog(@"%@", scrollView);
    
    //            float sizeOfContent = 0;
    //            UIView *lLast = [scrollView.subviews lastObject];
    //            NSInteger wd = lLast.frame.origin.y;
    //            NSInteger ht = lLast.frame.size.height;
    //
    //            sizeOfContent = wd+ht;
    //
    //            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, sizeOfContent);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    //NSLog(@"DID SCROLL");
    
    // do whatever you need to with scrollDirection here.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
