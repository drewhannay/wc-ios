//
//  StalkernetResults.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StalkernetResults : UIViewController 
    <UITableViewDataSource,
    UITableViewDelegate>{
        UITableView *mainTableView;
        NSDictionary *resultsList;
        UIImageView *image;
        NSString *searchParam;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSDictionary *resultsList;
@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) NSString *searchParam;

-(void) loadData;

@end
