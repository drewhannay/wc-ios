//
//  WhosWhoResults.h
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhosWhoResults : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *resultsList;
    NSMutableArray *profileImages;
}

@property (nonatomic, retain) IBOutlet UITableView *resultsList;
@property (nonatomic, retain) NSArray *searchResults;

@end
