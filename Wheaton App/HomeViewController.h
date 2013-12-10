//
//  HomeViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import <UIKit/UIKit.h>
#import "MasterTabViewController.h"
#import "HomeSearchDisplayController.h"

@interface HomeViewController : UIViewController {
    int priorSegmentIndex;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *switchViewControllers;
@property (nonatomic, copy) NSArray *allViewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end
