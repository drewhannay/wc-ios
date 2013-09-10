//
//  MenuTopViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 8/28/13.
//
//

#import "MenuTopViewController.h"

@interface MenuTopViewController ()

@end

@implementation MenuTopViewController

@synthesize activityView, menuBtn, webView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(self.view.bounds.size.width/2 - activityView.bounds.size.width/2, 52, activityView.bounds.size.width, activityView.bounds.size.height);
    [self.view addSubview:activityView];
    [activityView startAnimating];
    
    self.slidingViewController.underRightViewController = NULL;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8, 10, 34, 24);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
    
    NSString *urlAddress = c_Menu;
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:@"description"]) {
        htmlCode = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
//    if ([elementName isEqualToString:@"description"]) {
//        [webView loadHTMLString:htmlCode baseURL:nil];
//    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"description"]) {
        [htmlCode appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [webView loadHTMLString:htmlCode baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webview  {
    if (webview.isLoading)
        return;
    [activityView stopAnimating];
}

@end
