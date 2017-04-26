//
//  MUIPopMenuStrategyTool.m
//  MUIPopMenu
//
//  Created by xulihua on 2017/1/18.
//  Copyright © 2017年 ND. All rights reserved.
//

#import "MUIPopMenuStrategyTool.h"
#import "MUIPopMenuMacro.h"

@implementation MUIPopMenuStrategyTool


+ (CGRect)getItemAnimateViewRect:(NSInteger)itemCount fromRect:(CGRect)fromRect {
    if (itemCount == 0) {
        return CGRectZero;
    }
    NSInteger calculateCount = itemCount;
    if (itemCount > 9) {
        calculateCount = 9;
    }
    NSInteger column = 3;
    NSInteger rowIndex = (calculateCount-1) / column + 1;
    if (calculateCount == 2) {
        rowIndex = 2;
    }
    CGFloat ItemAnimateViewH = kMUIPopMenuButtonViewH*rowIndex + kMUIPopMenuButtonViewMarginY*(rowIndex-1);
    CGFloat currentItemAnimateViewY = CGRectGetMinY(fromRect) + CGRectGetHeight(fromRect)/2.0 - ItemAnimateViewH/2.0;
    CGFloat itemAnimateViewMinY = MUIPopMenuScreenHeight*0.07;
    CGFloat itemAnimateViewMaxY = MUIPopMenuScreenHeight - ItemAnimateViewH - MUIPopMenuScreenHeight*0.07*2-30;
    if (itemCount>9) {
        itemAnimateViewMaxY -= 25;
    }
    if (currentItemAnimateViewY < itemAnimateViewMinY) {
        currentItemAnimateViewY = itemAnimateViewMinY;
    } else if (currentItemAnimateViewY > itemAnimateViewMaxY) {
       currentItemAnimateViewY = itemAnimateViewMaxY;
    } else {
        
    }
    return CGRectMake(0, currentItemAnimateViewY, MUIPopMenuScreenWidth, ItemAnimateViewH);
}


+ (CGRect)getFrameAtIndex:(NSUInteger)index itemCount:(NSInteger)itemCount animationType:(MUIPopMenuViewAnimationType)animationType {
    CGRect rect = CGRectZero;
    if (itemCount == 0) {
        return rect;
    }
    if (animationType == MUIPopMenuViewAnimationTypeFromRect) {
        NSInteger totalPageValue = (itemCount-1)/9; //从0开始
        NSInteger currentPage = index/9;
        itemCount = itemCount % 9;
        if (itemCount == 0) {
            itemCount = 9;
        }
        NSInteger column = 3;
        if (itemCount == 2 && (index >= totalPageValue*9) && currentPage==0) {
            column = 1;
        }
        NSInteger colnumIndex = index % 9 % column; //列
        NSInteger rowIndex = index % 9 / column; //行
        CGFloat itemMinX = (MUIPopMenuScreenWidth-kMUIPopMenuButtonViewW*column-kMUIPopMenuButtonViewMarginX*(column-1))/2.0;
        CGFloat buttonViewX = (kMUIPopMenuButtonViewMarginX + kMUIPopMenuButtonViewW)*colnumIndex + itemMinX + currentPage*MUIPopMenuScreenWidth;
        
        if ((index % 9 == itemCount-1 && itemCount%column==1) || column == 1) {
            if (totalPageValue==0) {
                buttonViewX = (MUIPopMenuScreenWidth-kMUIPopMenuButtonViewW)/2.0 + currentPage * MUIPopMenuScreenWidth;
                
            }
        }
        
        CGFloat buttonViewY = (kMUIPopMenuButtonViewMarginY+ kMUIPopMenuButtonViewH)*rowIndex;
        rect = CGRectMake(buttonViewX, buttonViewY, kMUIPopMenuButtonViewW, kMUIPopMenuButtonViewH);
    } else {
        NSInteger column = 3;
        NSInteger colnumIndex = index % column;
        NSInteger rowIndex = index / column;
        NSUInteger toRows = ((itemCount-1) / column) + 1;
        
        CGFloat toHeight = toRows*kMUIPopMenuButtonViewH+(toRows-1)*kMUIPopMenuButtonViewMarginY;
        
        CGFloat itemMinX = (MUIPopMenuScreenWidth-kMUIPopMenuButtonViewW*column-kMUIPopMenuButtonViewMarginX*(column-1))/2.0;
        CGFloat buttonViewX = (kMUIPopMenuButtonViewMarginX + kMUIPopMenuButtonViewW)*colnumIndex + itemMinX;
        
        CGFloat buttonViewY = MUIPopMenuScreenHeight + rowIndex*(kMUIPopMenuButtonViewMarginY+kMUIPopMenuButtonViewH)  - (MUIPopMenuScreenHeight*0.14+30) - toHeight;
        rect = CGRectMake(buttonViewX, buttonViewY, kMUIPopMenuButtonViewW, kMUIPopMenuButtonViewH);
    }
    return rect;
}

@end
