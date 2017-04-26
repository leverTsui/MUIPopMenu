//
//  MUIPopMenuView.h
//  MUIPopMenuView
//
//  Created by  H y on 15/9/8.
//  Copyright (c) 2015年 ouy.Aberi. All rights reserved.
//

#import "MUIPopMenuViewDelegate.h"
#import "MUIPopMenuModel.h"
#import <UIKit/UIKit.h>

/**
 *  弹出动画类型
 *  animation Type
 */
typedef NS_ENUM(NSUInteger, MUIPopMenuViewAnimationType) {
    /**
     *  仿新浪App弹出菜单。
     *  Sina App fake pop-up menu
     */
    MUIPopMenuViewAnimationTypeSina,
    /**
     *  带有粘性的动画
     *  Animation with viscous
     */
    MUIPopMenuViewAnimationTypeViscous,
    /**
     *  底部中心点弹出动画
     *  The bottom of the pop-up animation center
     */
    MUIPopMenuViewAnimationTypeCenter,
    
    /**
     *  左和右弹出动画
     *  Left and right pop Anime
     */
    MUIPopMenuViewAnimationTypeLeftAndRight,
    
    /**
     *  从点击点处弹出动画
     *  Left and right pop Anime
     */
    MUIPopMenuViewAnimationTypeFromRect,
};

typedef enum : NSUInteger {
    /**
     *  light模糊背景类型。
     *  light blurred background type.
     */
    MUIPopMenuViewBackgroundTypeLightBlur,

    /**
     *  dark模糊背景类型。
     *  dark blurred background type.
     */
    MUIPopMenuViewBackgroundTypeDarkBlur,

    /**
     *  偏白半透明背景类型。
     *  Partial white translucent background type.
     */
    MUIPopMenuViewBackgroundTypeLightTranslucent,

    /**
     *  偏黑半透明背景类型。
     *  Partial translucent black background type.
     */
    MUIPopMenuViewBackgroundTypeDarkTranslucent,

    /**
     *  白~黑渐变色。
     *  Gradient color.
     */
    MUIPopMenuViewBackgroundTypeGradient,

} MUIPopMenuViewBackgroundType; //背景类型
//Background type

@interface MUIPopMenuView : UIView

@property (nonatomic, strong) NSArray<MUIPopMenuModel*>* dataSource;

@property (nonatomic, weak) id<MUIPopMenuViewDelegate> delegate;

/**
 *  背景类型默认为 'MUIPopMenuViewBackgroundTypeLightBlur'
 *  The default is 'MUIPopMenuViewBackgroundTypeLightBlur'
*/
@property (nonatomic, assign) MUIPopMenuViewBackgroundType backgroundType;

/**
 *  动画类型
 *  animation Type
 */
@property (nonatomic, assign) MUIPopMenuViewAnimationType animationType;

/**
 *  按钮文字颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  按钮文字大小
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  默认为 10.0f         取值范围: 0.0f ~ 20.0f
 *  default is 10.0f    Range: 0 ~ 20
 */
@property (nonatomic, assign) CGFloat popMenuSpeed;

/**
 *  按钮弹出位置
 */
@property (nonatomic, assign) CGRect fromRect;

+ (instancetype)shareInstance;

- (void)showMenu;

- (void)hideMenu;

- (BOOL)isOpenMenu;

@end

UIKIT_EXTERN NSString* const MUIPopMenuViewWillShowNotification;
UIKIT_EXTERN NSString* const MUIPopMenuViewDidShowNotification;
UIKIT_EXTERN NSString* const MUIPopMenuViewWillHideNotification;
UIKIT_EXTERN NSString* const MUIPopMenuViewDidHideNotification;
