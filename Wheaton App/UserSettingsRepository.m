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
#import "UserSettingsRepository.h"

@implementation UserSettingsRepository

-(void)setFYXServiceStarted:(BOOL)fyxServiceStarted {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* fyxServiceStartedAsString = fyxServiceStarted ? @"YES" : @"NO";
    [defaults setObject:fyxServiceStartedAsString forKey:@"fyx_service_started_key"];
    [defaults synchronize];
}

-(BOOL)getFYXServiceStarted {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* fyxServiceStartedAsString = [defaults objectForKey:@"fyx_service_started_key"];
    return [fyxServiceStartedAsString isEqualToString:@"YES"];
}

-(void)setRegistrationSkipped:(BOOL)registrationSkipped {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* registrationSkippedAsString = registrationSkipped ? @"YES" : @"NO";
    [defaults setObject:registrationSkippedAsString forKey:@"registration_skipped_key"];
    [defaults synchronize];
}

-(BOOL)getRegistrationSkipped {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* registrationSkippedAsString = [defaults objectForKey:@"registration_skipped_key"];
    return [registrationSkippedAsString isEqualToString:@"YES"];
}

@end
