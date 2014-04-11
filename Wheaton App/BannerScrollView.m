//
//  BannerScrollView.m
//  Wheaton App
//
//  Created by Chris Anderson on 8/31/13.
//
//

#import "BannerScrollView.h"
#import "WebViewController.h"

@implementation BannerScrollView
{
    int totalPages;
    NSArray *bannerImages;
    UIViewController *parentController;
}

@synthesize scrollView, pageControl;

- (void)loaded:(UIViewController *)parent
{
    parentController = parent;
    [scrollView setTag:1];
    [scrollView setAutoresizingMask:UIViewAutoresizingNone];
    [pageControl setTag:12];
    [pageControl setAutoresizingMask:UIViewAutoresizingNone];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImage:)];
    [self addGestureRecognizer:tapped];
    
    
    NSURL *URL = [NSURL URLWithString: c_Banners];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL: URL];
        if (data == nil) {
            [self addImage:[UIImage imageNamed:@"banner1.png"] index:0];
        } else {
            NSError *error;
            NSArray *images = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            bannerImages = images;
            for (int i = 0; i < [images count]; i++)
            {
                NSURL *imageURL = [NSURL URLWithString: [[images objectAtIndex:i] objectForKey:@"src"]];
                UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL: imageURL]];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self addImage:image index:i];
                    });
                }
            }
        }
        [self performSelectorOnMainThread:@selector(setupScrollView) withObject:nil waitUntilDone:NO];
    });
}

- (void)tappedImage: (UITapGestureRecognizer *)recognizer
{
    [self openURL:[[bannerImages objectAtIndex:pageControl.currentPage] objectForKey:@"url"]];
}

- (void)openURL:(NSString *)url
{
    if ([url length] != 0) {
        
        WebViewController *vc = [parentController.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
        vc.allowZoom = YES;
        vc.url = [NSURL URLWithString:url];
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Viewed Ad" properties:@{ @"URL": url }];
        
        vc.title = @"Banner Ad";
        [parentController.navigationController
         pushViewController:vc
         animated:YES];
        
        [vc.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)addImage:(UIImage *)image index:(int)i
{
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    imgV.contentMode = UIViewContentModeScaleToFill;
    [imgV setImage:image];
    imgV.tag = i + 2;
    [scrollView addSubview:imgV];
    totalPages++;
}

- (void)setupScrollView
{
    [pageControl setNumberOfPages:totalPages];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * totalPages, scrollView.frame.size.height)];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

- (void)scrollingTimer
{
    CGFloat contentOffset = scrollView.contentOffset.x;
    
    // calculate next page to display
    int nextPage = (int)(contentOffset/scrollView.frame.size.width) + 1;
    if(nextPage != totalPages)  {
        [scrollView scrollRectToVisible:CGRectMake(nextPage * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
        pageControl.currentPage = nextPage;
    } else {
        [scrollView scrollRectToVisible:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
        pageControl.currentPage = 0;
    }
}

- (IBAction)pageChanged:(id)sender
{
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}


@end
