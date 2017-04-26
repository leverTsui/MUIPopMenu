//
//  MUIPopMenuButton.h
//  MUIPopMenuView
//
//  Created by MUI_Mac on 16/7/8.
//  Copyright © 2016年 ouy.Aberi. All rights reserved.
//

#import "MUIPopMenuView.h"
#import <UIKit/UIKit.h>
//#import <QuartzCore/CAAnimation.h>

typedef void (^completionAnimation)( MUIPopMenuButton * obj );

#if defined(__IPHONE_10_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0)
@interface MUIPopMenuButton : UIButton <CAAnimationDelegate>
#else
@interface MUIPopMenuButton : UIButton
#endif

@property (nonatomic, weak, readonly) MUIPopMenuModel* model;

- (instancetype)initWithModel:(MUIPopMenuModel *)model;

@property (nonatomic, copy) completionAnimation block;

- (void)selectdAnimation;
- (void)cancelAnimation;

- (void)reset;

@end
