//
//  Banner.h
//  Wheaton App
//
//  Created by Chris Anderson on 2/20/14.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface Banner : NSObject

+ (void)setUser:(NSDictionary *)user success:(void (^)(NSDictionary *skips))success failure:(void (^)(NSError *err))failure;
+ (void)getChapelSkips:(void (^)(NSDictionary *skips))success failure:(void (^)(NSError *err))failure;
+ (void)getDegree:(void (^)(NSArray *degree))success failure:(void (^)(NSError *err))failure;
+ (void)account:(void (^)(NSDictionary *account))success failure:(void (^)(NSError *err))failure;
+ (void)importCalendar:(void (^)(NSArray *schedule))success failure:(void (^)(NSError *err))failure;
+ (BOOL)hasLoggedIn;
+ (void)logOut;
+ (NSString *)getSchoolID;

@end
