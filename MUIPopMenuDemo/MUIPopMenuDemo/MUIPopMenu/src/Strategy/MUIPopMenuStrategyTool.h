//
//  MUIPopMenuStrategyTool.h
//  MUIPopMenu
//
//  Created by xulihua on 2017/1/18.
//  Copyright © 2017年 ND. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MUIPopMenuView.h"

@interface MUIPopMenuStrategyTool : NSObject

+ (CGRect)getItemAnimateViewRect:(NSInteger)itemCount fromRect:(CGRect)fromRect;

+ (CGRect)getFrameAtIndex:(NSUInteger)index itemCount:(NSInteger)itemCount animationType:(MUIPopMenuViewAnimationType)animationType;

@end
