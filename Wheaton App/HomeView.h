//
//  HomeView.h
//  Wheaton App
//
//  Created by Chris Anderson on 8/31/13.
//
//

#import <UIKit/UIKit.h>

@interface HomeView : UIScrollView <UIScrollViewDelegate> {
    int totalPages;
    NSMutableArray *bannerImages;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

- (void)loaded;


@end
