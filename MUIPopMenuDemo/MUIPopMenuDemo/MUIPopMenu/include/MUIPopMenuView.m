//
//  MUIPopMenuView.m
//  MUIPopMenuView
//
//  Created by  H y on 15/9/8.
//  Copyright (c) 2015年 ouy.Aberi. All rights reserved.
//

#import "MUIPopMenuView.h"
#import "UIColor+MUIGetColor.h"
#import "UIImage+MUIImageEffects.h"
#import "MUIPopMenuMacro.h"
#import <pop/POP.h>
#import "UIImageView+MUIBlurredImage.h"
#import "MUIPopMenuImageManager.h"
#import "MUIPopMenuStrategyTool.h"
#import <Masonry/Masonry.h>
#import "MUIPopMenuButton.h"

#define kMUIPopMenuViewdisappearButtonW  30

@interface MUIPopMenuView ()<UICollectionViewDelegate> {
    BOOL isAlpha; //背景图是否透明
}

@property (nonatomic, weak) UIView* backgroundView;
@property (nonatomic, weak) UIScrollView* itemAnimateView;
@property (nonatomic, weak) UIButton* disappearButton;

@property(nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL isOpen;

@end

//截取全屏
UIImage * getScreenshot(UIView *view) NS_AVAILABLE_IOS(7_0);
UIImage * getScreenshot(UIView *view){
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@implementation MUIPopMenuView

#pragma mark - life cycle

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static MUIPopMenuView *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MUIPopMenuView alloc] init] ;
        [instance setFrame:[UIScreen mainScreen].bounds];
        instance.animationType = MUIPopMenuViewAnimationTypeFromRect;
        instance.backgroundType = MUIPopMenuViewBackgroundTypeLightBlur;
        instance.popMenuSpeed = 10.f;
    });
    return instance;
}

- (void)showMenu
{
    [[self getMainView] endEditing:YES]; //隐藏掉键盘
    self.isOpen = NO;
    [self addNotificationAtNotificationName:MUIPopMenuViewWillShowNotification];
    
    [self addPageSubViews];
    [self show];
    [self backgroundAnimate];
}

- (void)hideMenu
{
    [self addNotificationAtNotificationName:MUIPopMenuViewWillHideNotification];
    if (self.animationType == MUIPopMenuViewAnimationTypeFromRect) {
        [self closeWithDuration:0.3];
        return;
    }
    [self disappearPopMenuViewAnimate];
    [UIView animateWithDuration:0.3 animations:^{
        [self.disappearButton setAlpha:0];
    }];
    CGFloat d = (self.dataSource.count * 0.04) + 0.3;
    [UIView animateKeyframesWithDuration:MUIPopMenuDuration delay:d options:0 animations:^{
        [self.backgroundView setAlpha:0];
    }
                              completion:^(BOOL finished) {
                                  [self addNotificationAtNotificationName:MUIPopMenuViewDidHideNotification];
                                  self.isOpen = NO;
                                  [self.backgroundView removeFromSuperview];
                                  [self removeFromSuperview];
                              }];
}


- (void)addPageSubViews
{
    UIView *backgroundView = [self effectsViewWithType:self.backgroundType];
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
    
    UIButton* disappearButton = [_backgroundView viewWithTag:3];
    if (!disappearButton) {
        disappearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        disappearButton.adjustsImageWhenHighlighted = NO;
        disappearButton.tag = 3;
        
        [_backgroundView addSubview:disappearButton];
        _disappearButton = disappearButton;
        [disappearButton setImage:[UIImage imageNamed:@"chat_popup_top_icon_close_normal.png"] forState:UIControlStateNormal];
        [disappearButton setImage:[UIImage imageNamed:@"chat_popup_top_icon_close_pressed.png"] forState:UIControlStateHighlighted];
        disappearButton.alpha = 0;
        [disappearButton addTarget:self action:@selector(closeWithDuration:) forControlEvents:UIControlEventTouchUpInside];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = (self.dataSource.count-1)/9+1;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0 alpha:0.15];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0 alpha:0.35];
        [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
        [_backgroundView addSubview:_pageControl];
        _pageControl.alpha = 0;
    }    
    UIScrollView* itemAnimateView = [_backgroundView viewWithTag:2];
    if (self.animationType == MUIPopMenuViewAnimationTypeFromRect) {
        if (!itemAnimateView) {
            itemAnimateView = [[UIScrollView alloc] init];
            itemAnimateView.clipsToBounds = NO;
            itemAnimateView.frame = [MUIPopMenuStrategyTool getItemAnimateViewRect:self.dataSource.count fromRect:self.fromRect];
            [itemAnimateView setTag:2];
            itemAnimateView.delegate = self;
            itemAnimateView.pagingEnabled = YES;
            itemAnimateView.showsHorizontalScrollIndicator = NO;
            itemAnimateView.showsVerticalScrollIndicator = NO;
            [itemAnimateView setContentSize:CGSizeMake(((self.dataSource.count-1)/9+1) * MUIPopMenuScreenWidth, CGRectGetHeight(itemAnimateView.frame))];
            [_backgroundView addSubview:itemAnimateView];
            _itemAnimateView = itemAnimateView;
        }
        itemAnimateView.frame = [MUIPopMenuStrategyTool getItemAnimateViewRect:self.dataSource.count fromRect:self.fromRect];
        self.fromRect = [_backgroundView convertRect:self.fromRect toView:_itemAnimateView];
    } else {
        [_disappearButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_backgroundView.mas_centerX);
            make.width.mas_equalTo(kMUIPopMenuViewdisappearButtonW);
            make.height.mas_equalTo(kMUIPopMenuViewdisappearButtonW);
            make.bottom.equalTo(_backgroundView.mas_bottom).offset(-MUIPopMenuScreenHeight*0.07);
        }];
    }
}

#pragma mark - backgroundView

- (UIView *)effectsViewWithType:(MUIPopMenuViewBackgroundType)type
{
    if (_backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
    }
    isAlpha = true;
    UIView* effectView = nil;
    CAGradientLayer* gradientLayer = nil;
    id effectBlur = nil;
    switch (type) {
        case MUIPopMenuViewBackgroundTypeDarkBlur:
            if (kiOS8Later) {
                effectBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            } else {
                UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
                effectView = [self creatBackgroudViewWtihTintColor:tintColor];
            }
            break;
            
        case MUIPopMenuViewBackgroundTypeLightBlur:
            if (kiOS8Later) {
                effectBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            } else {
                UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.7];
                effectView = [self creatBackgroudViewWtihTintColor:tintColor];
            }
            break;
            
        case MUIPopMenuViewBackgroundTypeLightTranslucent:
        case MUIPopMenuViewBackgroundTypeDarkTranslucent:
            break;
            
        case MUIPopMenuViewBackgroundTypeGradient:
            gradientLayer = [self gradientLayerWithColor1:[UIColor colorWithWhite:1 alpha:0.1f] AtColor2:[UIColor colorWithWhite:0.0f alpha:1.0f]];
            break;
    }
    if (!effectView) {
        if (effectBlur) {
            isAlpha = false;
            effectView = [[UIVisualEffectView alloc] initWithEffect:effectBlur];
        } else {
            effectView = [[UIView alloc] init];
            if (gradientLayer) {
                [effectView.layer addSublayer:gradientLayer];
            } else {
                effectView.backgroundColor = [UIColor colorWithWhite:(CGFloat)(type == MUIPopMenuViewBackgroundTypeLightTranslucent) alpha:0.7];
            }
        }
    }
    effectView.frame = self.frame;
    effectView.alpha = 0.0f;
    return effectView;
}


- (UIImageView *)creatBackgroudViewWtihTintColor:(UIColor *)tintColor {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    UIColor *maskImageColor = [UIColor colorWithWhite:1.0 alpha:0.7];
//    UIImage *maskImage = [UIImage imageWithColor:maskImage size:CGSizeMake(MUIPopMenuScreenWidth, MUIPopMenuScreenHeight)];
    
    [imageView setImageToBlur:getScreenshot([self getMainView]) blurRadius:14 tintColor:tintColor  maskImage:nil completionBlock:NULL];
    return imageView;
}

- (void)closeWithDuration:(CGFloat)duration
{
    if (duration<CGFLOAT_MIN) {
        duration = 0.3;
    }
    if (self.animationType == MUIPopMenuViewAnimationTypeFromRect) {
        [UIView animateWithDuration:duration-0.1 animations:^{
            [self.itemAnimateView setAlpha:0];
        } completion:NULL];
    }
    [UIView animateWithDuration:duration animations:^{
        [self.backgroundView setAlpha:0];
        [self.disappearButton setAlpha:0];
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (BOOL)isOpenMenu
{
    return _isOpen;
}

#pragma mark - animate

//背景动画
- (void)backgroundAnimate
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = MUIPopMenuDuration;
    anim.fromValue = @(0.0);
    anim.toValue = @(1.0);
    [self.backgroundView  pop_addAnimation:anim forKey:@"fade"];
    
    [self showItemAnimate];
}

- (void)showItemAnimate
{
    CGFloat d = (self.dataSource.count * 0.04) + 0.3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(d * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addNotificationAtNotificationName:MUIPopMenuViewDidShowNotification];
    });
    [_dataSource enumerateObjectsUsingBlock:^(MUIPopMenuModel* model, NSUInteger idx, BOOL* _Nonnull stop) {
        if (self.textColor) {
            model.textColor = self.textColor;
        }
        if (self.titleFont) {
            model.titleFont = self.titleFont;
        }
        [model.menuButton reset];
        
        [model.menuButton addTarget:self action:@selector(selectedFunc:) forControlEvents:UIControlEventTouchUpInside];
        if (self.animationType == MUIPopMenuViewAnimationTypeFromRect) {
            [self.itemAnimateView addSubview:model.menuButton];
        } else {
            [self.backgroundView addSubview:model.menuButton];
        }

        CGRect toRect;
        CGRect fromRect = CGRectZero;
        CGFloat dy = idx * 0.035f;
        CFTimeInterval delay = dy + CACurrentMediaTime();

        switch (_animationType) {
        case MUIPopMenuViewAnimationTypeSina:
            toRect = [self getFrameAtIndex:idx];
            fromRect = CGRectMake(CGRectGetMinX(toRect),
                CGRectGetMinY(toRect) + 130,
                toRect.size.width,
                toRect.size.height);
            break;
        case MUIPopMenuViewAnimationTypeCenter:
            toRect = [self getFrameAtIndex:idx];
            fromRect = CGRectMake(CGRectGetMidX(self.frame) - CGRectGetWidth(fromRect) / 2,
                (CGRectGetMinY(toRect) + (- CGRectGetMinY(toRect))) - 25,
                toRect.size.width,
                toRect.size.height);
            break;
        case MUIPopMenuViewAnimationTypeViscous:
            toRect = [self getFrameAtIndex:idx];
            fromRect = CGRectMake(CGRectGetMinX(toRect),
                CGRectGetMinY(toRect) + (MUIPopMenuScreenHeight - CGRectGetMinY(toRect)),
                toRect.size.width,
                toRect.size.height);
            break;
        case MUIPopMenuViewAnimationTypeLeftAndRight:
            toRect = [self getFrameAtIndex:idx];
            CGFloat d = (idx % 2) == 0 ? 0:CGRectGetWidth(toRect);
            CGFloat x = ((idx % 2) * MUIPopMenuScreenWidth) - d;
            fromRect = CGRectMake(x,
                                  CGRectGetMinY(toRect) + (MUIPopMenuScreenWidth - CGRectGetMinY(toRect)),
                                  toRect.size.width,
                                  toRect.size.height);
            break;
        case MUIPopMenuViewAnimationTypeFromRect:
            toRect = [self getFrameAtIndex:idx];
            fromRect = self.fromRect;
            model.menuButton.center = CGPointMake(CGRectGetMidX(fromRect), CGRectGetMidY(fromRect));
            if (idx >= 9) {
                model.menuButton.frame = toRect;
                model.menuButton.alpha = 1.0f;
                return ;
            }
            break;
        }
        [self classAnimationWithfromRect:fromRect
                                  toRect:toRect
                                  deleay:delay
                                   views:model.menuButton
                                  isHidd:false];
        
        if (self.animationType == MUIPopMenuViewAnimationTypeFromRect && (idx == (_dataSource.count-1) || idx == 8)) {
            [self showDisappearButtonAnimate:delay+0.035f];
            if (self.dataSource.count>9) {
                [self showPageControlAnimate:delay+0.035f];
            }
        } else {
            if (idx == (_dataSource.count-1)) {
                [UIView animateWithDuration:0.3 delay:d options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.disappearButton.alpha = 1;

                } completion:NULL];
            }
        }
    }];
}

//显示消失按钮动画
- (void)showDisappearButtonAnimate:(CFTimeInterval)delay
{
    CGFloat disappearButtonTop =  CGRectGetMaxY(self.itemAnimateView.frame)+MUIPopMenuScreenHeight*0.07;
    if (self.dataSource.count > 9) {
        disappearButtonTop += 25;
    }
    CGRect disappearButtonToRect = CGRectMake((MUIPopMenuScreenWidth-kMUIPopMenuViewdisappearButtonW)/2.0, disappearButtonTop, kMUIPopMenuViewdisappearButtonW, kMUIPopMenuViewdisappearButtonW);
    CGRect disappearButtonFromRect = [self.itemAnimateView convertRect:self.fromRect toView:[self getMainView]];
    self.disappearButton.frame = CGRectMake(CGRectGetMidX(disappearButtonFromRect),CGRectGetMidY(disappearButtonFromRect), kMUIPopMenuViewdisappearButtonW, kMUIPopMenuViewdisappearButtonW);
    [self classAnimationWithfromRect:disappearButtonFromRect
                              toRect:disappearButtonToRect
                              deleay:delay
                               views:self.disappearButton
                              isHidd:false];
}

- (void)showPageControlAnimate:(CFTimeInterval)delay
{
    CGFloat pageControlTop =  CGRectGetMaxY(self.itemAnimateView.frame)+20;
    CGRect pageControlToRect = CGRectMake(0, pageControlTop, MUIPopMenuScreenWidth, 10);
    CGRect pageControlFromRect = [self.itemAnimateView convertRect:self.fromRect toView:[self getMainView]];
    self.pageControl.frame = CGRectMake(CGRectGetMidX(pageControlFromRect),CGRectGetMidY(pageControlFromRect), kMUIPopMenuViewdisappearButtonW, kMUIPopMenuViewdisappearButtonW);
    [self classAnimationWithfromRect:pageControlFromRect
                              toRect:pageControlToRect
                              deleay:delay
                               views:self.pageControl
                              isHidd:false];
}



- (void)disappearPopMenuViewAnimate
{
    [_dataSource enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        CGFloat d = self.dataSource.count * 0.04;
        CGFloat dy = d - idx * 0.04;
        MUIPopMenuModel* model = obj;
        CFTimeInterval delay = dy + CACurrentMediaTime();
        
        CGRect toRect = CGRectZero;
        CGRect fromRect;
        
        switch (_animationType) {
            case MUIPopMenuViewAnimationTypeSina:
                
                fromRect = [self getFrameAtIndex:idx];
                toRect = CGRectMake(CGRectGetMinX(fromRect),
                                    MUIPopMenuScreenHeight,
                                    CGRectGetWidth(fromRect),
                                    CGRectGetHeight(fromRect));
                
                break;
            case MUIPopMenuViewAnimationTypeCenter:
                
                fromRect = [self getFrameAtIndex:idx];
                toRect = CGRectMake(CGRectGetMidX(self.frame) - CGRectGetWidth(fromRect) / 2,
                                    (CGRectGetMinY(toRect) + (MUIPopMenuScreenHeight - CGRectGetMinY(toRect))) - 25,
                                    fromRect.size.width,
                                    fromRect.size.height);
                
                break;
            case MUIPopMenuViewAnimationTypeViscous:
                
                fromRect = [self getFrameAtIndex:idx];
                toRect = CGRectMake(CGRectGetMinX(fromRect),
                                    CGRectGetMinY(fromRect) + (MUIPopMenuScreenHeight - CGRectGetMinY(fromRect)),
                                    fromRect.size.width,
                                    fromRect.size.height);
                
                break;
            case MUIPopMenuViewAnimationTypeLeftAndRight:
                fromRect = [self getFrameAtIndex:idx];
                CGFloat d = (idx % 2) == 0 ? 0:CGRectGetWidth(fromRect);
                CGFloat x = ((idx % 2) * MUIPopMenuScreenWidth) - d;
                
                toRect = CGRectMake(x,
                                    CGRectGetMinY(fromRect) + (MUIPopMenuScreenHeight - CGRectGetMinY(fromRect)),
                                    fromRect.size.width,
                                    fromRect.size.height);
                break;
            case MUIPopMenuViewAnimationTypeFromRect:
                fromRect = [self getFrameAtIndex:idx];
                toRect = self.fromRect;
                if (idx >= 9) {
                    model.menuButton.frame = toRect;
                    model.menuButton.alpha = 0.0f;
                    return ;
                }
                break;
        }
        [self classAnimationWithfromRect:fromRect
                                  toRect:toRect
                                  deleay:delay
                                   views:model.menuButton
                                  isHidd:true];
    }];
}


- (void)classAnimationWithfromRect:(CGRect)age1
                            toRect:(CGRect)age2
                            deleay:(CFTimeInterval)age3
                             views:(UIView*)age4
                            isHidd:(BOOL)age5
{
    __weak MUIPopMenuView* weakView = self;
    if (_animationType == MUIPopMenuViewAnimationTypeSina) {

        [self startSinaAnimationfromValue:age1
                                  toValue:age2
                                    delay:age3
                                   object:age4
                          completionBlock:^(BOOL CompletionBlock) {
                              [weakView addTap];
                          }
                              hideDisplay:age5];
    }
    else if (_animationType == MUIPopMenuViewAnimationTypeViscous) {

        [self startViscousAnimationFormValue:age1
                                     ToValue:age2
                                       Delay:age3
                                      Object:age4
                             CompletionBlock:^(BOOL CompletionBlock) {
                                 [weakView addTap];
                             }
                                 HideDisplay:age5];
    }
    else if (_animationType == MUIPopMenuViewAnimationTypeCenter) {

        [self startSinaAnimationfromValue:age1
                                  toValue:age2
                                    delay:age3
                                   object:age4
                          completionBlock:^(BOOL CompletionBlock) {
                              [weakView addTap];
                          }
                              hideDisplay:age5];
    } else if (_animationType == MUIPopMenuViewAnimationTypeLeftAndRight) {
        [self startSinaAnimationfromValue:age1
                                  toValue:age2
                                    delay:age3
                                   object:age4
                          completionBlock:^(BOOL CompletionBlock) {
                              [weakView addTap];
                          }
                              hideDisplay:age5];
    }else if (_animationType == MUIPopMenuViewAnimationTypeFromRect) {
        [self startSinaAnimationfromValue:age1
                                  toValue:age2
                                    delay:age3
                                   object:age4
                          completionBlock:^(BOOL CompletionBlock) {
                              [weakView addTap];
                          }
                              hideDisplay:age5];
    } else {
        
    }
}


- (void)startViscousAnimationFormValue:(CGRect)fromValue
                               ToValue:(CGRect)toValue
                                 Delay:(CFTimeInterval)delay
                                Object:(UIView*)obj
                       CompletionBlock:(void (^)(BOOL CompletionBlock))completionBlock
                           HideDisplay:(BOOL)hideDisplay
{
    CGFloat toV, fromV;
    CGFloat springBounciness = 8.f;
    toV = !hideDisplay;
    fromV = hideDisplay;
    
    if (hideDisplay) {
        POPBasicAnimation* basicAnimationCenter = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        basicAnimationCenter.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        basicAnimationCenter.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        basicAnimationCenter.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        basicAnimationCenter.beginTime = delay;
        basicAnimationCenter.duration = 0.18;
        [obj pop_addAnimation:basicAnimationCenter forKey:basicAnimationCenter.name];
        
        POPBasicAnimation* basicAnimationScale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleX];
        basicAnimationScale.removedOnCompletion = YES;
        basicAnimationScale.beginTime = delay;
        basicAnimationScale.toValue = @(0.7);
        basicAnimationScale.fromValue = @(1);
        basicAnimationScale.duration = 0.18;
        basicAnimationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [obj.layer pop_addAnimation:basicAnimationScale forKey:basicAnimationScale.name];
    }
    else {
        POPSpringAnimation* basicAnimationCenter = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        basicAnimationCenter.beginTime = delay;
        basicAnimationCenter.springSpeed = _popMenuSpeed;
        basicAnimationCenter.springBounciness = springBounciness;
        basicAnimationCenter.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        basicAnimationCenter.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        
        POPBasicAnimation* basicAnimationScale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleX];
        basicAnimationScale.beginTime = delay;
        basicAnimationScale.toValue = @(1);
        basicAnimationScale.fromValue = @(0.7);
        basicAnimationScale.duration = 0.3f;
        basicAnimationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [obj.layer pop_addAnimation:basicAnimationScale forKey:basicAnimationScale.name];
        
        POPBasicAnimation* basicAnimationAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        basicAnimationAlpha.removedOnCompletion = YES;
        basicAnimationAlpha.duration = 0.1f;
        basicAnimationAlpha.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        basicAnimationAlpha.beginTime = delay;
        basicAnimationAlpha.toValue = @(toV);
        basicAnimationAlpha.fromValue = @(fromV);
        
        [obj pop_addAnimation:basicAnimationAlpha forKey:basicAnimationAlpha.name];
        [obj pop_addAnimation:basicAnimationCenter forKey:basicAnimationCenter.name];
        [basicAnimationCenter setCompletionBlock:^(POPAnimation* spring, BOOL Completion) {
            if (!completionBlock) {
                return;
            }
            if (Completion) {
                completionBlock(Completion);
            }
        }];
    }
}

- (void)startSinaAnimationfromValue:(CGRect)fromValue
                            toValue:(CGRect)toValue
                              delay:(CFTimeInterval)delay
                             object:(UIView*)obj
                    completionBlock:(void (^)(BOOL CompletionBlock))completionBlock
                        hideDisplay:(BOOL)hideDisplay
{
    
    CGFloat toV, fromV;

    CGFloat springBounciness = 10.f;
    toV = !hideDisplay;
    fromV = hideDisplay;
    
    if (hideDisplay) {
        POPBasicAnimation* basicAnimationCenter = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        basicAnimationCenter.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        basicAnimationCenter.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        basicAnimationCenter.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        basicAnimationCenter.beginTime = delay;
        basicAnimationCenter.duration = 0.18;
        [obj pop_addAnimation:basicAnimationCenter forKey:basicAnimationCenter.name];
        
        POPBasicAnimation* basicAnimationScale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        basicAnimationScale.removedOnCompletion = YES;
        basicAnimationScale.beginTime = delay;
        basicAnimationScale.toValue = [NSValue valueWithCGPoint:CGPointMake(0.7, 0.7)];
        basicAnimationScale.fromValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        basicAnimationScale.duration = 0.18;
        basicAnimationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [obj.layer pop_addAnimation:basicAnimationScale forKey:basicAnimationScale.name];
        [basicAnimationScale setCompletionBlock:NULL];
    }
    else {
        POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        springAnimation.removedOnCompletion = YES;
        springAnimation.beginTime = delay;
        springAnimation.springBounciness = springBounciness; // value between 0-20
        springAnimation.springSpeed = _popMenuSpeed; // value between 0-20
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        
        POPBasicAnimation* basicAnimationAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        basicAnimationAlpha.removedOnCompletion = YES;
        basicAnimationAlpha.duration = 0.2;
        basicAnimationAlpha.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        basicAnimationAlpha.beginTime = delay;
        basicAnimationAlpha.toValue = @(toV);
        basicAnimationAlpha.fromValue = @(fromV);
        [obj pop_addAnimation:basicAnimationAlpha forKey:basicAnimationAlpha.name];
        [obj pop_addAnimation:springAnimation forKey:springAnimation.name];
        [springAnimation setCompletionBlock:^(POPAnimation* spring, BOOL Completion) {
            if (!completionBlock) {
                return;
            }
            if (Completion) {
                completionBlock(Completion);
            }
        }];
    }
}

#pragma mark - event response

- (void)pageControlClick:(UIPageControl *)sender {
    NSInteger page = _pageControl.currentPage;
    CGFloat contentOffsetLeft = MUIPopMenuScreenWidth*page;
    [self.itemAnimateView setContentOffset:CGPointMake(contentOffsetLeft, 0 ) animated:YES];
}

- (void)selectedFunc:(MUIPopMenuButton*)sender
{
    @weakify(self)
    switch (sender.model.transitionType) {
        case MUIPopMenuTransitionTypeDefault:
            break;
        case MUIPopMenuTransitionTypeSystemApi:
        case MUIPopMenuTransitionTypeCustomizeApi: {
            for (MUIPopMenuModel *model in self.dataSource) {
                if (sender == model.menuButton) {
                    [sender selectdAnimation];
                } else {
                    [model.menuButton cancelAnimation];
                }
            }
            
        }
            break;
    }
    
    NSUInteger idx = [_dataSource indexOfObject:sender.model];
    switch (sender.model.transitionType) {
        case MUIPopMenuTransitionTypeCustomizeApi: {
            @weakify(sender)
            sender.block = ^(MUIPopMenuButton *btn) {
                @strongify(self)
                @strongify(sender)
                if ([self.delegate respondsToSelector:@selector(popMenuView:didSelectItemAtIndex:)]) {
                    [self.delegate popMenuView:self didSelectItemAtIndex:idx];
                }
                if (sender.model.buttonClickBlock) {
                    sender.model.buttonClickBlock(sender.model,idx);
                }
                [self closeWithDuration:0.5];
            };
            break;
        }
        case MUIPopMenuTransitionTypeDefault: {
            if ([self.delegate respondsToSelector:@selector(popMenuView:didSelectItemAtIndex:)]) {
                [self.delegate popMenuView:self didSelectItemAtIndex:idx];
            }
            if (sender.model.buttonClickBlock) {
                sender.model.buttonClickBlock(sender.model,idx);
            }
            [self closeWithDuration:0.3];
        }
            break;
        case MUIPopMenuTransitionTypeSystemApi: {
            if ([self.delegate respondsToSelector:@selector(popMenuView:didSelectItemAtIndex:)]) {
                [self.delegate popMenuView:self didSelectItemAtIndex:idx];
            }
            if (sender.model.buttonClickBlock) {
                sender.model.buttonClickBlock(sender.model,idx);
            }
            [self closeWithDuration:0.5];
        }
            break;
    }
}

#pragma mark - private method
- (void)addTap
{
    if (_isOpen) {
        return;
    }
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu)];
    [_backgroundView addGestureRecognizer:tap];
    _isOpen = true;
}

- (CGRect)getFrameAtIndex:(NSUInteger)index;
{
    return [MUIPopMenuStrategyTool getFrameAtIndex:index itemCount:self.dataSource.count animationType:self.animationType];
}


- (CAGradientLayer*)gradientLayerWithColor1:(UIColor*)color1 AtColor2:(UIColor*)color2
{
    CAGradientLayer* layer = [CAGradientLayer new];
    layer.colors = @[ (__bridge id)color1.CGColor, (__bridge id)color2.CGColor ];
    layer.startPoint = CGPointMake(0.5f, -0.5);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.frame = self.frame;
    return layer;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger page = floor(self.itemAnimateView.contentOffset.x / MUIPopMenuScreenWidth);
    self.pageControl.currentPage = page;
    
    CGFloat contentOffsetLeft = MUIPopMenuScreenWidth*page;
    [self.itemAnimateView setContentOffset:CGPointMake(contentOffsetLeft, 0 ) animated:YES];
}


#pragma mark - getter & setter

- (void)show
{
    UIWindow *window = (id)[self getMainView];
    if (self.superview) {
        [self removeFromSuperview];
    }
    [window addSubview:self];
}

- (UIWindow *)getMainView {
    UIWindow *window =[[UIApplication sharedApplication] keyWindow];
    if (!window) {
        window = [[[UIApplication sharedApplication] delegate] window];
    }
    return window;
}



- (void)addNotificationAtNotificationName:(NSString*)notificationNmae
{
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:notificationNmae object:self];
}

@end

NSString* const MUIPopMenuViewWillShowNotification = @"MUIPopMenuViewWillShowNotification";
NSString* const MUIPopMenuViewDidShowNotification = @"MUIPopMenuViewDidShowNotification";
NSString* const MUIPopMenuViewWillHideNotification = @"MUIPopMenuViewWillHideNotification";
NSString* const MUIPopMenuViewDidHideNotification = @"MUIPopMenuViewDidHideNotification";
