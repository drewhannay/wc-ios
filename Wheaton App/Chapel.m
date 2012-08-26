//
//  Chapel.m
//  Wheaton App
//
//  Created by Drew Hannay on 7/27/11.
//  Copyright 2011 Wheaton College. All rights reserved.
//

#import "Chapel.h"
#import "HomeScreen.h"

@implementation Chapel

@synthesize loadingView;
@synthesize webView;
@synthesize todayButton;
@synthesize previousButton;
@synthesize nextButton;

-(void)fetchedData:(NSData *)responseData
{
    @try
    {
        //parse out the json data
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        NSArray* jsonChapels = [json objectForKey:@"chapels"];

        // init with number of chapels over three as a rough estimate of number of weeks
        m_chapelWeeks = [[NSMutableArray alloc] initWithCapacity: [jsonChapels count] / 3];
        for (int index = 0; index < [jsonChapels count]; index++)
        {
            if (![self addDay:[jsonChapels objectAtIndex:index]])
            {
                [m_currentWeek appendString:@"</body></html>"];
                [m_chapelWeeks addObject:m_currentWeek];
                m_currentWeek = nil;
                [self addDay:[jsonChapels objectAtIndex:index]];
            }
        }
        [m_currentWeek appendString:@"</body></html>"];
        [m_chapelWeeks addObject:m_currentWeek];

    }
    @catch (NSException *e)
    {
        [self loadErrorView];
    }

    if (m_errorOccurred)
        [self loadErrorView];

    [loadingView stopAnimating];

    m_viewIndex = m_todayIndex;
    [webView loadHTMLString:[m_chapelWeeks objectAtIndex:m_viewIndex] baseURL:nil];

    [self setNextButtonVisibility];
    [self setPreviousButtonVisibility];
}

-(void)loadErrorView
{
    m_todayIndex = 0;
    m_chapelWeeks = [[NSMutableArray alloc] initWithObjects:@"<html><head><style type=\"text/css\"> h1 { font-size: 1.2em; font-weight: bold; "
                    "text-align: center; }</style></head><body><br/><br/><br/><br/><h1>The chapel schedule is not yet available. Check back soon!</h1></body></html>",
                     nil ];
}

-(void)setNextButtonVisibility
{
    if (m_viewIndex == ([m_chapelWeeks count] - 1))
        nextButton.hidden = true;
    else
        nextButton.hidden = false;
}

-(void)setPreviousButtonVisibility
{
    if (m_viewIndex == 0)
        previousButton.hidden = true;
    else
        previousButton.hidden = false;
}

-(BOOL) addDay:(NSDictionary *)chapelDay
{
    @try
    {
        NSArray *weekdays = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];

        if (m_currentWeek == nil)
        {
            m_currentWeek = [[NSMutableString alloc] initWithString: @"<html><head><style type=\"text/css\"> h1 { font-size: 1.1em; font-weight: bold;"
                           "text-align: center; color:#CC6600; } h2 { text-align: center; font-size: 0.9em; } h3 { text-align: center;"
                           "font-style:italic; font-size: 0.8em;}p { text-align: center; font-size: 0.7em; } </style></head><body>"];
            m_lastDay = @"Sunday";
        }

        NSString *newDay = [chapelDay objectForKey:@"Date"];
        newDay = [newDay substringToIndex:[newDay rangeOfString:@","].location];

        for (NSString *day in weekdays)
        {
            if ([day isEqualToString:newDay])
                return false;
            if ([day isEqualToString:m_lastDay])
                break;
        }

        m_lastDay = newDay;

        if (m_todayIndex < 0)
        {
            NSDate *date = [m_dateFormatter dateFromString:[[chapelDay objectForKey:@"Date"] stringByAppendingString:@" 11 : 15"]];
            NSDate *today = [[NSDate alloc] init];
            if ([[date laterDate:today] isEqualToDate:date])
                m_todayIndex = [m_chapelWeeks count];
        }

        bool isSpecialSeries = [chapelDay objectForKey:@"Special Series"];

        [m_currentWeek appendString:@"<h1>"];
        [m_currentWeek appendString:[chapelDay objectForKey:@"Date"]];
        [m_currentWeek appendString:@"</h1>"];

        if (isSpecialSeries)
            [m_currentWeek appendString:@"<span style=\"color:#000066;\">"];

        [m_currentWeek appendString:@"<h2>"];
        [m_currentWeek appendString:[chapelDay objectForKey:@"Speakers"]];
        [m_currentWeek appendString:@"</h2>"];

        [m_currentWeek appendString:@"<h3>"];
        [m_currentWeek appendString:[chapelDay objectForKey:@"Title"]];
        [m_currentWeek appendString:@"</h3>"];

        [m_currentWeek appendString:@"<p>"];
        [m_currentWeek appendString:[chapelDay objectForKey:@"Description"]];
        [m_currentWeek appendString:@"</p>"];

        if (isSpecialSeries)
            [m_currentWeek appendString:@"</span>"];

        [m_currentWeek appendString:@"<hr />"];
    }
    @catch (NSException *e)
    {
        m_errorOccurred = true;
    }
    return true;
}

-(IBAction) switchPage:(UIButton *)button
{
    if (m_isWorking)
        return;

    m_isWorking = true;

    if (button == nextButton)
    {
        m_viewIndex++;
        [webView loadHTMLString:[m_chapelWeeks objectAtIndex:m_viewIndex] baseURL:nil];
        [self setNextButtonVisibility];
        previousButton.hidden = false;
    }
    else if (button == previousButton)
    {
        m_viewIndex--;
        [webView loadHTMLString:[m_chapelWeeks objectAtIndex:m_viewIndex] baseURL:nil];
        [self setPreviousButtonVisibility];
        nextButton.hidden = false;
    }
    else if (button == todayButton)
    {
        m_viewIndex = m_todayIndex;
        [webView loadHTMLString:[m_chapelWeeks objectAtIndex:m_viewIndex] baseURL:nil];
        [self setNextButtonVisibility];
        [self setPreviousButtonVisibility];
    }

    m_isWorking = false;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // hide both the buttons and set them visible later if needed
    previousButton.hidden = true;
    nextButton.hidden = true;
    
    m_todayIndex = -1;
    
    m_dateFormatter = [[NSDateFormatter alloc] init];
    [m_dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy HH : mm"];
    
    [loadingView startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: CHAPEL_URL]];
        NSArray *cachesDirList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDir = [cachesDirList objectAtIndex:0];
        if (data != nil)
            [data writeToURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", cacheDir, @"chapels.json"]] atomically:YES];
        else
            data = [NSData dataWithContentsOfURL: [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", cacheDir, @"chapels.json"]]];
        
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

@end