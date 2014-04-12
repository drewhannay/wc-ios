//
//  Sport.m
//  Wheaton App
//
//  Created by Chris Anderson on 12/14/13.
//
//

#import "Sport.h"


@implementation Sport

@synthesize time;
@synthesize opponent;
@synthesize team;
@synthesize score;
@synthesize sport;
@synthesize home;
@synthesize gender;

- (SportTableCell *)generateCell:(SportTableCell *)cell {
    
    cell.time.text = [time lowercaseString];
    
    [cell.sport setHidden:NO];
    if ([sport isEqualToString:@"Soccer"])
        cell.sport.image = [UIImage imageNamed:@"Soccer.png"];
    else if ([sport isEqualToString:@"Basketball"])
        cell.sport.image = [UIImage imageNamed:@"Basketball.png"];
    else if ([sport isEqualToString:@"Volleyball"])
        cell.sport.image = [UIImage imageNamed:@"Volleyball.png"];
    else if ([sport isEqualToString:@"Golf"])
        cell.sport.image = [UIImage imageNamed:@"Golf.png"];
    else if ([sport isEqualToString:@"Football"])
        cell.sport.image = [UIImage imageNamed:@"Football.png"];
    else if ([sport isEqualToString:@"Tennis"])
        cell.sport.image = [UIImage imageNamed:@"Tennis.png"];
    else if ([sport isEqualToString:@"Swimming"])
        cell.sport.image = [UIImage imageNamed:@"Swimming.png"];
    else if ([sport isEqualToString:@"Baseball"] || [sport isEqualToString:@"Softball"])
        cell.sport.image = [UIImage imageNamed:@"Baseball.png"];
    else
        [cell.sport setHidden:YES];
    
    cell.team.text = team;
    cell.opponent.text = opponent;
    
    if (home) {
        [cell.home setHidden:FALSE];
    } else {
        [cell.home setHidden:TRUE];
    }
    
    if (score && [score count] > 0) {
        cell.scoreOpponent.text = [score objectForKey:@"other"];
        cell.scoreSchool.text = [score objectForKey:@"school"];
    }
    
    return cell;
}

- (void)jsonToSport:(NSDictionary *)json {
    NSDictionary *result = json;
    NSDictionary *custom = [result objectForKey:@"custom"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[result objectForKey:@"timeStamp"] objectAtIndex:0] doubleValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"MM/dd hh:mm a"];
    
    time = [dateFormatter stringFromDate:date];
    sport = (NSString *)[result objectForKey:@"title"];
    score = [custom objectForKey:@"score"];
    team = [NSString stringWithFormat:@"%@. %@", [[[custom objectForKey:@"gender"] substringToIndex:1] uppercaseString], [sport capitalizedString]];
    opponent = [custom objectForKey:@"opponent"];
    home = [(NSNumber *)[custom objectForKey: @"home"] isEqual: @(YES)];
}

@end
