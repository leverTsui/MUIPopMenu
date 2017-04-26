//
//  UIImageView+MUIBlurredImage.m
//  MUIPopMenu
//
//  Created by xulihua on 2017/1/12.
//  Copyright © 2017年 ND. All rights reserved.
//

#import "UIImageView+MUIBlurredImage.h"
#import "UIImage+MUIImageEffects.h"


CGFloat const kMUIBlurredImageDefaultBlurRadius            = 20.0;
CGFloat const kMUIBlurredImageDefaultSaturationDeltaFactor = 1.8;

@implementation UIImageView (MUIBlurredImage)

#pragma mark - LBBlurredImage Additions

- (void)setImageToBlur:(UIImage *)image
       completionBlock:(MUIBlurredImageCompletionBlock)completion
{
    [self setImageToBlur:image
              blurRadius:kMUIBlurredImageDefaultBlurRadius
         completionBlock:completion];
}

- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
       completionBlock:(MUIBlurredImageCompletionBlock) completion
{
    NSParameterAssert(image);
    NSParameterAssert(blurRadius >= 0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *blurredImage = [image applyBlurWithRadius:blurRadius
                                                 tintColor:nil
                                     saturationDeltaFactor:kMUIBlurredImageDefaultSaturationDeltaFactor
                                                 maskImage:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = blurredImage;
            if (completion) {
                completion();
            }
        });
    });
}

- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
             tintColor:(UIColor *)tintColor
             maskImage:(UIImage *)maskImage
       completionBlock:(MUIBlurredImageCompletionBlock)completion {
    NSParameterAssert(image);
    NSParameterAssert(blurRadius >= 0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *blurredImage = [image applyBlurWithRadius:blurRadius
                                                 tintColor:tintColor
                                     saturationDeltaFactor:kMUIBlurredImageDefaultSaturationDeltaFactor
                                                 maskImage:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = blurredImage;
            if (completion) {
                completion();
            }
        });
    });
}

@end
