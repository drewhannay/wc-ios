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

@synthesize person, image, firstName, lastName, email;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    firstName.text = person.firstName;
    lastName.text = person.lastName;
    email.text = person.email;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
