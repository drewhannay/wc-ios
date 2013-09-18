//
//  EventsCollectionViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 9/1/13.
//
//

#import <UIKit/UIKit.h>

@interface EventsCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSXMLParserDelegate> {
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *date;
    NSString *element;
    NSDateFormatter *dateFormatter;
    NSCalendar *calendar;
}

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *schedule;
@property NSInteger *displayResults;

@end
