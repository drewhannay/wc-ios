//
//  OpenFloor.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "OpenFloor.h"
#import "HomeScreen.h"


@implementation OpenFloor

@synthesize loadingView;
@synthesize webView;
@synthesize todayButton;
@synthesize prevButton;
@synthesize nextButton;

-(void)fetchedData:(NSData *)responseData
{
    NSMutableArray *floorData = [[NSMutableArray alloc] initWithCapacity:7];

    @try
    {
        // parse out the json data
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];

        NSArray *weekdays = [[NSArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];

        for (NSString *weekday in weekdays)
            [floorData addObject:[self addDay:[json objectForKey:weekday]]];
        
    }
    @catch (NSException *exception)
    {
        m_errorOccurred = true;
    }

    if (m_errorOccurred)
        [self loadErrorView];
    else
        m_openFloorDays = [[NSArray alloc] initWithArray:floorData];

    [loadingView stopAnimating];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    m_todayIndex = [comps weekday] - 1;
    m_viewIndex = m_todayIndex;
    [webView loadHTMLString:[m_openFloorDays objectAtIndex:m_viewIndex] baseURL:nil];

    [self setNextButtonVisibility];
    [self setPreviousButtonVisibility];
}

-(void)loadErrorView
{
    m_todayIndex = 0;
    m_openFloorDays = [NSArray arrayWithObject:@"<html><head><style type=\"text/css\"> h1 { font-size: 1.2em; font-weight: bold;text-align: center; }"
               "</style></head><body><br/><br/><br/><br/><h1>The open floor schedule is not yet available. Check back soon!</h1></body></html>"];
}

-(void)setNextButtonVisibility
{
    if (m_viewIndex == ([m_openFloorDays count] - 1))
        nextButton.hidden = true;
    else
        nextButton.hidden = false;
}

-(void)setPreviousButtonVisibility
{
    if (m_viewIndex == 0)
        prevButton.hidden = true;
    else
        prevButton.hidden = false;
}

-(NSString *)addDay:(NSDictionary *)jsonData
{
    NSMutableString *builder = [[NSMutableString alloc] initWithString:@"<head><style type=\"text/css\"> h1 { font-size: 1.1em; font-weight: bold; "
                                "text-align: center; color:#CC6600; } h2 { text-align: center; font-size: 0.9em; } h3 { font-style:italic; font-size: 0.8em;}"
                                "p { text-align: center; font-size: 0.7em; } </style></head>"];
    @try
    {
        [builder appendFormat:@"<h1>%@</h1>", [self getFormattedDate:[jsonData objectForKey:@"Date"]]];

        [builder appendString:@"<h2>Open Fischer Floors:</h2>"];
        [self appendToBuilder:builder fromBuildingData:[jsonData objectForKey:@"Fischer"]];

        [builder appendString:@"<br /><h2>Open Smith/Traber Floors:</h2>"];
        [self appendToBuilder:builder fromBuildingData:[jsonData objectForKey:@"Smith/Traber"]];
    }
    @catch (NSException *exception)
    {
        m_errorOccurred = true;
    }

    [builder appendString:@"</body></html>"];

    return [[NSString alloc] initWithString:builder];
}

-(void)appendToBuilder:(NSMutableString *)builder fromBuildingData:(NSArray *)building
{
    [builder appendString:@"<p>"];

    if (building != nil)
    {
        for (NSDictionary *floor in building)
            [builder appendFormat:@"%@ - Open %@<br/>", [floor objectForKey:@"Floor"], [floor objectForKey:@"Open Hours"]];
    }
    else
    {
        [builder appendString:@"All Floors Closed"];
    }

    [builder appendString:@"</p>"];
}

-(NSString *)getFormattedDate:(NSString *)rawDate
{
    [m_dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    NSDate *date = [m_dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 23:59",rawDate]];
    if ([m_latestDate isEqualToDate:[m_latestDate laterDate:date]])
        m_latestDate = date;

    [m_dateFormatter setDateFormat:@"EEEE, MMMM d, y"];
    return [m_dateFormatter stringFromDate:date];
}

-(IBAction) switchPage:(UIButton *)button
{
    if (m_isWorking)
        return;

    m_isWorking = true;

    if(button==nextButton)
    {
        m_viewIndex++;
        [webView loadHTMLString:[m_openFloorDays objectAtIndex:m_viewIndex] baseURL:nil];
        [self setNextButtonVisibility];
        prevButton.hidden = false;
    }
    else if(button==prevButton)
    {
        m_viewIndex--;
        [webView loadHTMLString:[m_openFloorDays objectAtIndex:m_viewIndex] baseURL:nil];
        [self setPreviousButtonVisibility];
        nextButton.hidden = false;
    }
    else if(button==todayButton)
    {        
        m_viewIndex = m_todayIndex;
        [webView loadHTMLString:[m_openFloorDays objectAtIndex:m_viewIndex] baseURL:nil];
        [self setNextButtonVisibility];
        [self setPreviousButtonVisibility];
    }

    m_isWorking = false;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // hide both the buttons and set them visible later if needed
    prevButton.hidden = true;
    nextButton.hidden = true;

    m_dateFormatter = [[NSDateFormatter alloc] init];

    m_todayIndex = -1;

    [loadingView startAnimating];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: OPEN_FLOOR_URL]];
        NSArray *cachesDirList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDir = [cachesDirList objectAtIndex:0];
        if (data != nil)
            [data writeToURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", cacheDir, @"openFloor.json"]] atomically:YES];
        else
            data = [NSData dataWithContentsOfURL: [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", cacheDir, @"openFloor.json"]]];

        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

@end
