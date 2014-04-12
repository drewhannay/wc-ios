//
//  CourseRequirement.h
//  Wheaton App
//
//  Created by Chris Anderson on 3/18/14.
//
//

#import <Foundation/Foundation.h>

@interface CourseRequirement : NSObject

@property NSString *type;
@property NSString *met;
@property NSArray *courses;
@property NSArray *missing;

@end
