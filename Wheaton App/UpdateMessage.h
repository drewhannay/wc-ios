//
//  UpdateMessage.h
//  Wheaton App
//
//  Created by Drew Hannay on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UpdateMessage : UIViewController {
    UITextView *messageView;
    NSString *updateText;
}

@property (nonatomic, retain) IBOutlet UITextView *messageView;
@property (nonatomic, retain) NSString *updateText;

@end
