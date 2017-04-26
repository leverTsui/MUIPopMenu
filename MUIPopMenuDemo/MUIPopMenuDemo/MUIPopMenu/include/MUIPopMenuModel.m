//
//  MUIPopMenuModel.m
//  MUIPopMenuView
//
//  Created by MUI_Mac on 16/7/8.
//  Copyright © 2016年 ouy.Aberi. All rights reserved.
//

#import "MUIPopMenuModel.h"
#import "MUIPopMenuButton.h"
#import "MUIPopMenuMacro.h"

@implementation MUIPopMenuModel


+ (instancetype)popMenuModelWithImage:(UIImage *)image
                          titleString:(NSString *)title
                       transitionType:(MUIPopMenuTransitionType)transitionType
                     buttonClickBlock:(MUIPopMenuButtonClickBlock)buttonClickBlock {
    return [[MUIPopMenuModel alloc] initWithImage:image
                                   highlightImage:nil
                                        imageName:nil
                               highlightImageName:nil
                                      titleString:title
                                   transitionType:transitionType
                         transitionRenderingColor:nil
                                 buttonClickBlock:buttonClickBlock];;
}

+ (instancetype)popMenuModelWithImageName:(NSString *)imageName
                       highlightImageName:(NSString *)highlightImageName
                              titleString:(NSString *)title
                           transitionType:(MUIPopMenuTransitionType)transitionType
                 transitionRenderingColor:(UIColor *)transitionRenderingColor {
    return [[MUIPopMenuModel alloc] initWithImage:nil
                                   highlightImage:nil
                                        imageName:imageName
                               highlightImageName:highlightImageName
                                      titleString:title
                                   transitionType:transitionType
                         transitionRenderingColor:transitionRenderingColor
                                 buttonClickBlock:NULL];
}

+ (instancetype)popMenuModelWithImage:(UIImage *)image
                       highlightImage:(UIImage *)highlightImage
                          titleString:(NSString *)title
                       transitionType:(MUIPopMenuTransitionType)transitionType
             transitionRenderingColor:(UIColor *)transitionRenderingColor {
    return [[MUIPopMenuModel alloc] initWithImage:image
                                   highlightImage:highlightImage
                                        imageName:nil
                               highlightImageName:nil
                                      titleString:title
                                   transitionType:transitionType
                         transitionRenderingColor:transitionRenderingColor
                                 buttonClickBlock:NULL];
}

- (instancetype)initWithImageName:(NSString *)imageName
               highlightImageName:(NSString *)highlightImageName
                      titleString:(NSString *)title
                   transitionType:(MUIPopMenuTransitionType)transitionType
         transitionRenderingColor:(UIColor *)transitionRenderingColor
{
    return [self initWithImage:nil
                highlightImage:nil
                     imageName:imageName
            highlightImageName:highlightImageName
                   titleString:title
                transitionType:transitionType
      transitionRenderingColor:transitionRenderingColor
              buttonClickBlock:NULL];
}

- (instancetype)initWithImage:(UIImage *)image
               highlightImage:(UIImage *)highlightImage
                  titleString:(NSString *)title
               transitionType:(MUIPopMenuTransitionType)transitionType
     transitionRenderingColor:(UIColor *)transitionRenderingColor {
     return [self initWithImage:image
                 highlightImage:highlightImage
                      imageName:nil
             highlightImageName:nil
                    titleString:title
                 transitionType:transitionType
       transitionRenderingColor:transitionRenderingColor
               buttonClickBlock:NULL];
}

- (instancetype)initWithImage:(UIImage *)image
               highlightImage:(UIImage *)highlightImage
                    imageName:(NSString *)imageName
           highlightImageName:(NSString *)highlightImageName
                  titleString:(NSString *)title
               transitionType:(MUIPopMenuTransitionType)transitionType
     transitionRenderingColor:(UIColor *)transitionRenderingColor
             buttonClickBlock:(MUIPopMenuButtonClickBlock)buttonClickBlock {
    self = [super init];
    if (self) {
        self.image = image;
        self.highlightImage = highlightImage;
        
        self.imageName = imageName;
        self.highlightImageName = highlightImageName;
        
        self.title = title;
        self.transitionType = transitionType;
        self.transitionRenderingColor = transitionRenderingColor;
        self.textColor = MUIPopMenuSkin_COLOR_KEY_2;
        self.titleFont = MUIPopMenuSkin_FONT_KEY_8;
        MUIPopMenuButton* button = [[MUIPopMenuButton alloc] initWithModel:self];
        self.menuButton = button;
        self.buttonClickBlock = buttonClickBlock;
    }
    return self;
}

@end
