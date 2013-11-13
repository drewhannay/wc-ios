//
//  Person.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import "Person.h"

@implementation Person

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
