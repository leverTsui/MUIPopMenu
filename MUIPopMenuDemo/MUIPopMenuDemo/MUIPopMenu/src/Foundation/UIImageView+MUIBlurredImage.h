//
//  UIImageView+MUIBlurredImage.h
//  MUIPopMenu
//
//  Created by xulihua on 2017/1/12.
//  Copyright © 2017年 ND. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MUIBlurredImageCompletionBlock)(void);

extern CGFloat const kMUIBlurredImageDefaultBlurRadius;

@interface UIImageView (MUIBlurredImage)


/**
 Set the blurred version of the provided image to the UIImageView
 with the default blur radius
 
 @param UIImage the image to blur and set as UIImageView's image
 @param LBBlurredImageCompletionBlock a completion block called after the image
 was blurred and set to the UIImageView (the block is dispatched on main thread)
 */
- (void)setImageToBlur:(UIImage *)image
       completionBlock:(MUIBlurredImageCompletionBlock)completion;

/**
 Set the blurred version of the provided image to the UIImageView
 
 @param UIImage the image to blur and set as UIImageView's image
 @param CGFLoat the radius of the blur used by the Gaussian filter
 @param LBBlurredImageCompletionBlock a completion block called after the image
 was blurred and set to the UIImageView (the block is dispatched on main thread)
 */
- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
       completionBlock:(MUIBlurredImageCompletionBlock)completion;


- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
             tintColor:(UIColor *)tintColor
             maskImage:(UIImage *)maskImage
       completionBlock:(MUIBlurredImageCompletionBlock)completion;
@end
