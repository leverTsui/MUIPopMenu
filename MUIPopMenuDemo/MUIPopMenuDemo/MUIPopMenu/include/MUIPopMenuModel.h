//
//  MUIPopMenuModel.h
//  MUIPopMenuView
//
//  Created by MUI_Mac on 16/7/8.
//  Copyright © 2016年 ouy.Aberi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MUIPopMenuTransitionTypeDefault,
    MUIPopMenuTransitionTypeSystemApi,
    MUIPopMenuTransitionTypeCustomizeApi,
} MUIPopMenuTransitionType;

@class MUIPopMenuButton;
@interface MUIPopMenuModel : NSObject

typedef void(^MUIPopMenuButtonClickBlock)(MUIPopMenuModel* popMenuModel, NSUInteger index);


@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *highlightImageName;


@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightImage;

/**
 *  按钮文字颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  按钮文字大小
 */
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIColor *transitionRenderingColor;

@property (nonatomic, assign) MUIPopMenuTransitionType transitionType;

@property (nonatomic, strong) MUIPopMenuButton* menuButton;

@property (nonatomic, copy) MUIPopMenuButtonClickBlock buttonClickBlock;

+ (instancetype)popMenuModelWithImage:(UIImage *)image
                          titleString:(NSString *)title
                        transitionType:(MUIPopMenuTransitionType)transitionType
                        buttonClickBlock:(MUIPopMenuButtonClickBlock)buttonClickBlock;

+ (instancetype)popMenuModelWithImageName:(NSString *)imageName
                       highlightImageName:(NSString *)highlightImageName
                              titleString:(NSString *)title
                           transitionType:(MUIPopMenuTransitionType)transitionType
                 transitionRenderingColor:(UIColor *)transitionRenderingColor;

+ (instancetype)popMenuModelWithImage:(UIImage *)image
                       highlightImage:(UIImage *)highlightImage
                          titleString:(NSString *)title
                       transitionType:(MUIPopMenuTransitionType)transitionType
             transitionRenderingColor:(UIColor *)transitionRenderingColor;

- (instancetype)initWithImageName:(NSString *)imageName
               highlightImageName:(NSString *)highlightImageName
                      titleString:(NSString *)title
                   transitionType:(MUIPopMenuTransitionType)transitionType
         transitionRenderingColor:(UIColor *)transitionRenderingColor;

- (instancetype)initWithImage:(UIImage *)image
               highlightImage:(UIImage *)highlightImage
                  titleString:(NSString *)title
               transitionType:(MUIPopMenuTransitionType)transitionType
     transitionRenderingColor:(UIColor *)transitionRenderingColor;

@end
