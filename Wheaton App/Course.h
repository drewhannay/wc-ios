//
//  Course.h
//  Wheaton App
//
//  Created by Chris Anderson on 3/18/14.
//
//

#import <Foundation/Foundation.h>
#import "CourseTableCell.h"

@interface Course : NSObject

@property NSString *met;
@property NSString *subject;
@property NSString *requirement;
@property NSString *number;
@property NSString *name;
@property NSString *credits;
@property NSString *grade;

- (CourseTableCell *)generateCell:(CourseTableCell *)cell;
- (void)jsonParse:(NSDictionary *)json;

@end
