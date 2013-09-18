//
//  MTReachabilityManager.h
//  Reachability
//
//  Created by Bart Jacobs on 28/06/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface MTReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

#pragma mark -
#pragma mark Shared Manager
+ (MTReachabilityManager *)sharedManager;

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

@end
