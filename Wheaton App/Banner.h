//
//  Banner.h
//  Wheaton App
//
//  Created by Chris Anderson on 2/20/14.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "AFNetworking.h"

@interface Banner : NSObject

+ (void)setUser:(NSDictionary *)user success:(void (^)(NSDictionary *skips))success failure:(void (^)(NSError *err))failure;
+ (void)getChapelSkips:(void (^)(NSDictionary *skips))success failure:(void (^)(NSError *err))failure;
+ (void)getDegree:(void (^)(NSDictionary *degree))success failure:(void (^)(NSError *err))failure;
+ (BOOL)hasLoggedIn;

@end
