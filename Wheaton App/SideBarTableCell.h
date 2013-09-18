//
//  SideBarTableCell.h
//  Wheaton App
//
//  Created by Chris Anderson on 3/13/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SideBarTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *icon;

@end
