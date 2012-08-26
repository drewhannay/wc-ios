//
//  WhosWhoSearch.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "WhosWhoSearch.h"
#import "HomeScreen.h"

@implementation WhosWhoSearch

@synthesize searchBox;
@synthesize loadingView;

-(void) runSearch
{
    searchParameter = [searchBox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    searchParameter = [searchParameter stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    if([searchParameter isEqualToString:@""])
    {
        [[[iToast makeText:NSLocalizedString(@"Please enter a search term", @"")] setDuration:3000] show];
        return;
    }

    [loadingView startAnimating];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WHOS_WHO_PREFIX, searchParameter]]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *)responseData
{
    [loadingView stopAnimating];

    if (responseData == nil)
    {
        [[[iToast makeText:@"You must be connected to the Wheaton College Wifi Network to use this feature"] setDuration:3000] show];
        return;
    }
    
    // parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *searchResults = [json objectForKey:@"search_results"];

    if ([searchResults count] > 0)
    {
        WhosWhoResults *resultScreen = [[WhosWhoResults alloc] initWithNibName:@"WhosWhoResults" bundle:[NSBundle mainBundle]];
        resultScreen.navigationItem.title = searchParameter;
        resultScreen.searchResults = searchResults;
        [self.navigationController pushViewController:resultScreen animated:YES];
    }
    else
    {
        [[[iToast makeText:NSLocalizedString(@"No results", @"")] setDuration:3000] show];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self runSearch];
    return NO;
}

#pragma mark - View lifecycle

@end
