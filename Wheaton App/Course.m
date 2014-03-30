//
//  Course.m
//  Wheaton App
//
//  Created by Chris Anderson on 3/18/14.
//
//

#import "Course.h"

@implementation Course

- (CourseTableCell *)generateCell:(CourseTableCell *)cell {
    
    NSLog(@"%@", _subject);
    
    cell.courseLabel.text = [NSString stringWithFormat:@"%@ %@", _subject, _number];
    cell.nameLabel.text = _name;
    cell.creditsLabel.text = _credits;

    return cell;
}

- (void)jsonParse:(NSDictionary *)json {
    NSDictionary *result = json;
    
    self.met = [result objectForKey:@"met"];
    self.subject = [result objectForKey:@"subject"];
    self.requirement = [result objectForKey:@"requirement"];
    self.number = [result objectForKey:@"course"];
    self.name = [result objectForKey:@"name"];
    self.credits = [result objectForKey:@"credits"];
    self.grade = [result objectForKey:@"grade"];
}

@end
