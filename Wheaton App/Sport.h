//
//  Sport.h
//  Wheaton App
//
//  Created by Chris Anderson on 12/14/13.
//
//

#import <Foundation/Foundation.h>
#import "SportTableCell.h"

@interface Sport : NSObject

@property NSString *time;
@property NSString *opponent;
@property NSString *team;
@property NSString *gender;
@property (nonatomic, copy) NSDictionary *score;
@property NSString *sport;
@property BOOL *home;

- (UITableViewCell *)generateCell:(SportTableCell *)cell;
- (void)jsonToSport:(NSDictionary *)json;

@end
