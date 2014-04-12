//
//  Banner.m
//  Wheaton App
//
//  Created by Chris Anderson on 2/20/14.
//
//

#import "Banner.h"
#import "Course.h"
#import "CourseRequirement.h"

@implementation Banner

+ (void)setUser:(NSDictionary *)user success:(void (^)(NSDictionary *skips))success failure:(void (^)(NSError *err))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"%@/set", c_Banner];
    
    [manager POST:url parameters:user success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic objectForKey:@"success"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"user"] forKey:@"schoolID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            success(dic);
        } else {
            [self logOut];
            failure([NSError errorWithDomain:@"Incorrect email or password" code:0 userInfo:nil]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getChapelSkips:(void (^)(NSDictionary *skips))success failure:(void (^)(NSError *err))failure
{
    if([Banner hasLoggedIn]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *url = [NSString stringWithFormat:@"%@/chapel", c_Banner];
        
        [manager POST:url parameters:[Banner getUser] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = responseObject;
            success(dic);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
}

+ (void)getDegree:(void (^)(NSArray *degree))success failure:(void (^)(NSError *err))failure
{
    if([Banner hasLoggedIn]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *url = [NSString stringWithFormat:@"%@/degree", c_Banner];
        
        [manager POST:url parameters:[Banner getUser] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *dic = responseObject;
            
            NSMutableArray *requirements = [[NSMutableArray alloc] init];
            
            for (NSDictionary *requirement in dic) {
                CourseRequirement *cr = [[CourseRequirement alloc] init];
                cr.met = [requirement objectForKey:@"sectionMet"];
                cr.type = [requirement objectForKey:@"sectionType"];
                
                NSMutableArray *courses = [[NSMutableArray alloc] init];
                
                for (NSDictionary *course in [requirement objectForKey:@"classes"]) {
                    Course *c = [[Course alloc] init];
                    [c jsonParse:course];
                    [courses addObject:c];
                }
                
                cr.courses = courses;
                cr.missing = [requirement objectForKey:@"warnings"];
                [requirements addObject:cr];
            }
            
            success(requirements);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
}

+ (void)account:(void (^)(NSDictionary *account))success failure:(void (^)(NSError *err))failure
{
    if([Banner hasLoggedIn]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *url = [NSString stringWithFormat:@"%@/account", c_Banner];
        
        [manager POST:url parameters:[Banner getUser] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = responseObject;
            success(dic);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
}

+ (void)importCalendar:(void (^)(NSArray *schedule))success failure:(void (^)(NSError *err))failure
{
    if([Banner hasLoggedIn]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *url = [NSString stringWithFormat:@"%@/schedule", c_Banner];
        
        [manager POST:url parameters:[Banner getUser] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            EKEventStore *store = [[EKEventStore alloc] init];
            
            NSArray *schedule = responseObject;
            
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                    } else if (!granted) {
                    } else {
                        EKEventStore *store = [[EKEventStore alloc] init];
                        
                        for (NSDictionary *class in schedule) {
                            EKEvent *event  = [EKEvent eventWithEventStore:store];
                            event.title = [class objectForKey:@"title"];
                            event.location = [class objectForKey:@"location"];
                            
                            event.startDate = [NSDate dateWithTimeIntervalSince1970: [[class objectForKey:@"timeStart"] doubleValue]];
                            event.endDate = [NSDate dateWithTimeIntervalSince1970: [[class objectForKey:@"timeStop"] doubleValue]];
                            
                            NSDate *end = [NSDate dateWithTimeIntervalSince1970: [[class objectForKey:@"recurringStop"] doubleValue]];
                            
                            EKRecurrenceEnd *ekEnd = [EKRecurrenceEnd recurrenceEndWithEndDate:end];
                            
                            EKRecurrenceRule *er = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1
                                                                                           daysOfTheWeek:nil
                                                                                          daysOfTheMonth:nil
                                                                                         monthsOfTheYear:nil
                                                                                          weeksOfTheYear:nil
                                                                                           daysOfTheYear:nil
                                                                                            setPositions:nil
                                                                                                     end:ekEnd];
                            event.recurrenceRules = @[er];
                            event.availability = EKEventAvailabilityBusy;
                            
                            [event setCalendar:[store defaultCalendarForNewEvents]];
                            
                            NSError *err;
                            [store saveEvent:event span:EKSpanThisEvent error:&err];
                        }
                    }
                });
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
}


+ (BOOL)hasLoggedIn
{
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types
        && [[NSUserDefaults standardUserDefaults] boolForKey:@"login"]
        && [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]
        && [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        return YES;
    }
    return NO;
}

+ (void)logOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"favorites"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"schoolID"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getUser
{
    return @{
             @"uuid": [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"],
             @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
             };
}

+ (NSString *)getSchoolID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolID"];
}

@end
