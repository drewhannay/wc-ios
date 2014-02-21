//
//  UIImage_Scale.h
//  Wheaton App
//
//  Created by Chris Anderson on 2/17/14.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

- (UIImage *)scaleToWidth:(CGFloat)width constraint:(CGFloat)height;

@end

@implementation UIImage (Scale)

-(UIImage *)scaleToWidth:(CGFloat)width constraint:(CGFloat)height
{
    UIImage *scaledImage = self;
    if (self.size.width != width) {
        CGFloat aHeight = floorf(self.size.height * (width / self.size.width));
        if (aHeight > height) {
            width = floorf(self.size.width * (height / self.size.height));
        } else {
            height = aHeight;
        }
        CGSize size = CGSizeMake(width, height);

        UIGraphicsBeginImageContext(size);
        
        [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        
        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return scaledImage;
}


@end