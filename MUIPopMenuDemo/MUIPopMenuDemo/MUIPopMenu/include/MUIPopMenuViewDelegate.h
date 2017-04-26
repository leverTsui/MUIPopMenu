//
//  MUIPopMenuViewDelegate.h
//  MUIPopMenuView
//
//  Created by MUI_Mac on 16/7/12.
//  Copyright © 2016年 ouy.Aberi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MUIPopMenuView, MUIPopMenuModel, MUIPopMenuButton;

@protocol MUIPopMenuViewDelegate <NSObject>

- (void)popMenuView:(MUIPopMenuView*)popMenuView didSelectItemAtIndex:(NSUInteger)index;

//....
@end
