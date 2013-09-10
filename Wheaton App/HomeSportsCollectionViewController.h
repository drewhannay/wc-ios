//
//  HomeSportsCollectionViewController.h
//  Wheaton App
//
//  Created by Chris Anderson on 9/1/13.
//
//

#import <UIKit/UIKit.h>

@interface HomeSportsCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *sportResults;

@end
