//
//  UIColor+MUIImageGetColor.m
//  MUIPopMenuView
//
//  Created by  H y on 15/9/8.
//  Copyright (c) 2015年 ouy.Aberi. All rights reserved.
//

#import "UIColor+MUIGetColor.h"
#import "MUIPopMenuMacro.h"


@implementation UIColor (MUIGetColor)

+ (UIColor*)getPixelColorAtLocation:(CGPoint)point inImage:(UIImage*)image
{
    UIColor* color = nil;
    CGImageRef inImage = image.CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:
                                   inImage];
    if (cgctx == NULL) {
        return nil;
    }
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = { { 0, 0 }, { w, h } };
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char* data = CGBitmapContextGetData(cgctx);
    if (data != NULL) {
        NSInteger offset = 4 * ((w * round(point.y)) + round(point.x));
        NSInteger alpha = data[offset];
        NSInteger red = data[offset + 1];
        NSInteger green = data[offset + 2];
        NSInteger blue = data[offset + 3];
        color = [UIColor colorWithRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha:(alpha / 255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) {
        free(data);
    }
    return color;
}

+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void* bitmapData;
    unsigned long bitmapByteCount;
    unsigned long bitmapBytesPerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
//        MUPLogError(@"createARGBBitmapContextFromImage: Error allocating color space\n");
        return NULL;
    }
    bitmapData = malloc(bitmapByteCount);
    if (bitmapData == NULL) {
//        MUPLogError(@"createARGBBitmapContextFromImage: Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    context = CGBitmapContextCreate(bitmapData,pixelsWide,pixelsHigh,8,bitmapBytesPerRow,colorSpace,(CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        free(bitmapData);
//        MUPLogError(@"createARGBBitmapContextFromImage: Context not created!");
    }
    CGColorSpaceRelease(colorSpace);
    return context;
}

@end
