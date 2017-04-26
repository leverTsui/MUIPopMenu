//
//  MUIPopMenuButton.m
//  MUIPopMenuView
//
//  Created by MUI_Mac on 16/7/8.
//  Copyright © 2016年 ouy.Aberi. All rights reserved.
//

#import "MUIPopMenuButton.h"
#import "UIColor+MUIGetColor.h"
#import "MUIPopMenuMacro.h"

@implementation MUIPopMenuButton
- (instancetype)initWithModel:(MUIPopMenuModel *)model
{
    self = [super init];
    if (self) {
        _model = model;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.adjustsImageWhenHighlighted = NO;
        self.layer.masksToBounds = YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self setTitleColor:model.textColor forState:UIControlStateNormal];
        self.titleLabel.font = model.titleFont;
        [self setTitle:model.title forState:UIControlStateNormal];
        UIImage *normalImage = model.image;
        UIImage *highlightImage = model.highlightImage;
        if (!normalImage) {
            normalImage = [UIImage imageNamed:model.imageName];
            highlightImage = [UIImage imageNamed:model.highlightImageName];
        }
        [self setImage:normalImage forState:UIControlStateNormal];
        [self setImage:highlightImage forState:UIControlStateHighlighted];
        
        [self addTarget:self action:@selector(scaleToSmall)
       forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(scaleToDefault)
       forControlEvents:UIControlEventTouchDragExit];
    }
    return self;
}

- (void)scaleToSmall
{
    CABasicAnimation* theAnimation;
    theAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    theAnimation.delegate = self;
    theAnimation.duration = 0.1;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = NO;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1];
    theAnimation.toValue = [NSNumber numberWithFloat:1.2f];
    [self.layer addAnimation:theAnimation forKey:theAnimation.keyPath];
}

- (void)scaleToDefault
{
    CABasicAnimation* theAnimation;
    theAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    theAnimation.delegate = self;
    theAnimation.duration = 0.1;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = NO;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1.2f];
    theAnimation.toValue = [NSNumber numberWithFloat:1];
    [self.layer addAnimation:theAnimation forKey:theAnimation.keyPath];
}

- (void)selectdAnimation
{
    switch (_model.transitionType) {
        case MUIPopMenuTransitionTypeDefault:
            
            break;
        case MUIPopMenuTransitionTypeSystemApi: {
            CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.delegate = self;
            scaleAnimation.duration = 0.2;
            scaleAnimation.repeatCount = 0;
            scaleAnimation.removedOnCompletion = NO;
            scaleAnimation.fillMode = kCAFillModeForwards;
            scaleAnimation.autoreverses = NO;
            scaleAnimation.fromValue = @1;
            scaleAnimation.toValue = @1.4;
            
            CABasicAnimation* opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.delegate = self;
            opacityAnimation.duration = 0.2;
            opacityAnimation.repeatCount = 0;
            opacityAnimation.removedOnCompletion = NO;
            opacityAnimation.fillMode = kCAFillModeForwards;
            opacityAnimation.autoreverses = NO;
            opacityAnimation.fromValue = @1;
            opacityAnimation.toValue = @0;
            
            [self.layer addAnimation:scaleAnimation forKey:scaleAnimation.keyPath];
            [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
        }
            
            break;
        case MUIPopMenuTransitionTypeCustomizeApi: {
            self.userInteractionEnabled = NO;
            self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
            UIImage* image = self.imageView.image;
            UIColor* color = [UIColor getPixelColorAtLocation:CGPointMake(50, 20) inImage:image];
            [self setBackgroundColor:color];
            if (_model.transitionRenderingColor) {
                [self setBackgroundColor:_model.transitionRenderingColor];
            }
            [self setTitle:@"" forState:UIControlStateNormal];
            [self setImage:nil forState:UIControlStateNormal];
            
            CABasicAnimation* expandAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            expandAnim.fromValue = @(1.0);
            expandAnim.toValue = @(33.0);
            expandAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.95:0.02:1:0.05];
            expandAnim.duration = 0.3;
            expandAnim.delegate = self;
            expandAnim.fillMode = kCAFillModeForwards;
            expandAnim.removedOnCompletion = NO;
            expandAnim.autoreverses = NO;
            [self.layer addAnimation:expandAnim forKey:expandAnim.keyPath];
        }
            break;
            
        default:
            break;
    }
}

- (void)cancelAnimation
{

    CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.delegate = self;
    scaleAnimation.duration = 0.3;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @0.3;

    CABasicAnimation* opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.delegate = self;
    opacityAnimation.duration = 0.3;
    opacityAnimation.beginTime = 0;
    opacityAnimation.repeatCount = 0;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    //CGAffineTransformIdentity
    [self.layer addAnimation:scaleAnimation forKey:[NSString stringWithFormat:@"cancel%@", scaleAnimation.keyPath]];
    [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
}

- (void)animationDidStop:(CAAnimation*)anim finished:(BOOL)flag
{

    CABasicAnimation* cab = (CABasicAnimation*)anim;
    if ([cab.toValue floatValue] == 33.0f || [cab.toValue floatValue] == 1.4f) {
        [self setUserInteractionEnabled:true];
        __weak MUIPopMenuButton* weakButton = self;
        if (weakButton.block) {
            weakButton.block(self);
        }

        [NSTimer scheduledTimerWithTimeInterval:0.6f target:self selector:@selector(DidStopAnimation) userInfo:nil repeats:NO];
    }
}

- (void)DidStopAnimation
{

    [self.layer removeAllAnimations];
}

#pragma mark 调整内部ImageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageWidth = 53;
    CGFloat imageX = CGRectGetWidth(contentRect) / 2 - imageWidth / 2;
    CGFloat imageHeight = 56;
    CGFloat imageY = 0;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

#pragma mark 调整内部UILabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleHeight = self.model.titleFont.pointSize;
    CGFloat titleY = contentRect.size.height - titleHeight;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

- (void)reset {
    self.transform = CGAffineTransformIdentity;
    self.layer.transform = CATransform3DIdentity;

    self.layer.opacity = 1;
    self.layer.cornerRadius = 0;
    self.alpha = 0.0f;
    
    if (self.superview) {
        [self removeFromSuperview];
    }
    [self.layer removeAllAnimations];
    [self setBackgroundColor:[UIColor clearColor]];
    self.frame = CGRectMake(0, 0, kMUIPopMenuButtonViewW, kMUIPopMenuButtonViewH);
    UIImage *normalImage = self.model.image;
    UIImage *highlightImage =self. model.highlightImage;
    if (!normalImage) {
        normalImage = [UIImage imageNamed:self.model.imageName];
        highlightImage = [UIImage imageNamed:self.model.highlightImageName];
    }
    [self setImage:normalImage forState:UIControlStateNormal];
    [self setImage:highlightImage forState:UIControlStateHighlighted];
    
    [self setTitle:self.model.title forState:UIControlStateNormal];
    [self setTitleColor:self.model.textColor forState:UIControlStateNormal];
    self.titleLabel.font = self.model.titleFont;
}

@end
