//
//  MapDetailViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 2/9/14.
//
//

#import <UIKit/UIKit.h>
#import "JCRBlurView.h"
#import "Location.h"

@interface MapDetailViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *buildingImage;
@property (strong, nonatomic) IBOutlet UIView *bottomBlur;
@property (strong, nonatomic) JCRBlurView *blurView;

@property (strong, nonatomic) Location *building;
@property (strong, nonatomic) NSMutableArray *buildingTable;

@end
