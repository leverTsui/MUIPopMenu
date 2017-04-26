//
//  UIImage+MUIImageEffects.h
//  MUIPopMenu
//
//  Created by xulihua on 2017/1/12.
//  Copyright © 2017年 ND. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MUIImageEffects)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
