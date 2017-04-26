//
//  UIColor+MUIImageGetColor.h
//  MUIPopMenuView
//
//  Created by  H y  on 15/9/8.
//  Copyright (c) 2015年 ouy.Aberi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MUIGetColor)

+ (UIColor*)getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image;

@end


