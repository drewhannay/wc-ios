//
//  MTReachabilityManager.m
//  Reachability
//
//  Created by Bart Jacobs on 28/06/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import "MTReachabilityManager.h"
#import "Reachability.h"

@implementation MTReachabilityManager

#pragma mark -
#pragma mark Default Manager
+ (MTReachabilityManager *)sharedManager {
    static MTReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable {
    return [[[MTReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL)isUnreachable {
    return ![[[MTReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL)isReachableViaWWAN {
    return [[[MTReachabilityManager sharedManager] reachability] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi {
    return [[[MTReachabilityManager sharedManager] reachability] isReachableViaWiFi];
}

#pragma mark -
#pragma mark Private Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityWithHostname:@"intra.wheaton.edu"];
        
        // Start Monitoring
        [self.reachability startNotifier];
    }
    
    return self;
}

@end
