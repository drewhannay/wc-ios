//
//  Person.h
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property NSString *firstName;
@property NSString *lastName;
@property NSString *prefName;
@property NSString *classification;
@property NSString *email;
@property NSString *photo;
@property NSString *cpo;
@property NSString *uid;

- (NSString *)fullName;
- (NSString *)fullNameWithPref;

@end