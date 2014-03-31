/**
 * Copyright (C) 2013 Qualcomm Retail Solutions, Inc. All rights reserved.
 *
 * This software is the confidential and proprietary information of Qualcomm
 * Retail Solutions, Inc.
 *
 * The following sample code illustrates various aspects of the FYX iOS SDK.
 *
 * The sample code herein is provided for your convenience, and has not been
 * tested or designed to work on any particular system configuration. It is
 * provided pursuant to the License Agreement for FYX Software and Developer
 * Portal AS IS, and your use of this sample code, whether as provided or with
 * any modification, is at your own risk. Neither Qualcomm Retail Solutions,
 * Inc. nor any affiliate takes any liability nor responsibility with respect
 * to the sample code, and disclaims all warranties, express and implied,
 * including without limitation warranties on merchantability, fitness for a
 * specified purpose, and against infringement.
 */
#import "ApplicationContext.h"
#import <FYX/FYXLogging.h>


@implementation ApplicationContext

static ApplicationContext *sharedInstance = nil;

+ (ApplicationContext *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
        sharedInstance.userSettingRepository = [[UserSettingsRepository alloc] init];
    }

    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void) initializeFyxService {
    //Replace with your own Application-ID and Application-Secret to see your
    //activated beacons
    [FYX setAppId:@"73681eef9f4fe5bdd7c0c64b658610d5f52c5dd5a56b806fbb1e2f7c6e123e03"
         appSecret:@"ac3c3df423ee40d0eec289c177465871acd66ca35ca832485af547807ddf132d"
         callbackUrl:@"thunderstruck://com.centerdialstudio.proximity"];
    [FYXLogging setLogLevel:FYX_LOG_LEVEL_INFO];
}

- (void)didArriveIBeacon:(FYXiBeaconVisit *)visit
{
    NSLog(@"############## didArrive: %@", visit);
}

- (void)receivedIBeaconSighting:(FYXiBeaconVisit *)visit updateTime:(NSDate *)updateTime  RSSI:(NSNumber *)RSSI
{
    NSLog(@"############## didReceiveSighting: %@", visit);
}

- (void)didDepartIBeacon:(FYXiBeaconVisit *)visit
{
    NSLog(@"############## didDepart: %@", visit);
}

@end