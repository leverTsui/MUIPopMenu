//
//  UIModuleViewController.m
//  UIModule
//
//  Created by devp on 5/12/15.
//  Copyright (c) 2015 ND. All rights reserved.
//

#import "MUIPopMenuViewController.h"
#import "MUIPopMenuView.h"
#import <Masonry/Masonry.h>
#import "MUIPopMenuMacro.h"

@interface MUIPopMenuViewController () <MUIPopMenuViewDelegate>

@property (nonatomic, strong) MUIPopMenuView* menu;
@property (nonatomic, strong) UIImageView *backgroudIV;
@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIButton *middleButton;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) NSInteger random;


@end

@implementation MUIPopMenuViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addPageSubviews];
    [self layoutPageSubviews];
}

- (void)addPageSubviews {
    [self.view addSubview:self.backgroudIV];
    [self.view addSubview:self.topButton];
    [self.view addSubview:self.middleButton];
    [self.view addSubview:self.bottomButton];
}

- (void)layoutPageSubviews {
    @weakify(self)
    [self.backgroudIV mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.edges.mas_equalTo(self.view);
    }];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.mas_equalTo(self.view.mas_top).offset(40);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(49);
    }];
    [self.middleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(49);
    }];
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-40);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(49);
    }];
}

#pragma mark - event response
- (void)showMenu:(UIButton*)sender
{
    switch (sender.tag) {
        case 1000: {
            self.menu.animationType = MUIPopMenuViewAnimationTypeFromRect;
        }
            break;
        case 1001: {
            self.menu.animationType = MUIPopMenuViewAnimationTypeFromRect;
        }
            break;
        case 1002: {
            self.menu.animationType = MUIPopMenuViewAnimationTypeFromRect;
        }
            break;
            
        default:
            break;
    }
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.dataArr];
    self.menu.dataSource = [mutableArr copy];
    self.random += 1;
    if (self.random > self.menu.dataSource.count) {
        self.random = 0;
    }
//    self.random = 12;
    NSMutableArray *randomArr = [NSMutableArray arrayWithCapacity:self.menu.dataSource.count];
    for (MUIPopMenuModel *model in self.menu.dataSource) {
        [randomArr addObject:model];
        if (randomArr.count == self.random) {
            break;
        }
    }
    self.menu.dataSource = [randomArr copy];
    CGRect convertRect = [sender.superview convertRect:sender.frame toView:nil];
    self.menu.backgroundType = MUIPopMenuViewBackgroundTypeLightBlur;
    self.menu.fromRect = convertRect;
    [self.menu showMenu];
}

#pragma mark - MUIPopMenuViewDelegate
- (void)popMenuView:(MUIPopMenuView*)popMenuView
didSelectItemAtIndex:(NSUInteger)index
{
    
}

#pragma mark - getter & setter
- (MUIPopMenuView *)menu {
    if (!_menu) {
        _menu = [MUIPopMenuView shareInstance];
        _menu.delegate = self;
        _menu.popMenuSpeed = 12.0f;
//        _menu.animationType = MUIPopMenuViewAnimationTypeViscous;
    }
    return _menu;
}

- (UIButton *)topButton {
    if (!_topButton) {
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _topButton.titleLabel.textColor = [UIColor blueColor];
        [_topButton setTitle:@"顶部按钮" forState:UIControlStateNormal];
        [_topButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _topButton.tag = 1000;
        [_topButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topButton;
}

- (UIButton *)middleButton {
    if (!_middleButton) {
        _middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _middleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _middleButton.titleLabel.textColor = [UIColor blueColor];
        [_middleButton setTitle:@"中间按钮" forState:UIControlStateNormal];
        [_middleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _middleButton.tag = 1001;
        [_middleButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middleButton;
}


- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_bottomButton setTitle:@"底部按钮" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _bottomButton.tag = 1002;
        [_bottomButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

- (UIImageView *)backgroudIV {
    if (!_backgroudIV) {
        _backgroudIV = [[UIImageView alloc] init];
        _backgroudIV.image = [UIImage imageNamed:@"huoying4.jpg"];
    }
    return _backgroudIV;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        UIImage *modelImage = [UIImage imageNamed:@"tabbar_compose_idea"];
        MUIPopMenuModel* model = [MUIPopMenuModel
                                  popMenuModelWithImage:modelImage
                                  titleString:@"文字/头条"
                                  transitionType:MUIPopMenuTransitionTypeDefault
                                  buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                      
                                  }];
        
        MUIPopMenuModel* model1 = [MUIPopMenuModel
                                   popMenuModelWithImageName:@"tabbar_compose_photo"
                                   highlightImageName:nil
                                   titleString:@"相册/视频"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        
        MUIPopMenuModel* model2 = [MUIPopMenuModel
                                   popMenuModelWithImageName:@"tabbar_compose_camera"
                                   highlightImageName:nil
                                   titleString:@"拍摄/短视频"                                   transitionType:MUIPopMenuTransitionTypeCustomizeApi
                                   transitionRenderingColor:nil];
        
        MUIPopMenuModel* model3 = [MUIPopMenuModel
                                   popMenuModelWithImageName:@"tabbar_compose_lbs"
                                   highlightImageName:nil
                                   titleString:@"签到"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        
        MUIPopMenuModel* model4 = [MUIPopMenuModel
                                   popMenuModelWithImageName:@"tabbar_compose_review"
                                   highlightImageName:nil
                                   titleString:@"点评"
                                   transitionType:MUIPopMenuTransitionTypeCustomizeApi
                                   transitionRenderingColor:nil];
        MUIPopMenuModel* model5 = [MUIPopMenuModel
                                   popMenuModelWithImageName:@"tabbar_compose_more"
                                   highlightImageName:nil
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        MUIPopMenuModel* model6 = [MUIPopMenuModel
                                   popMenuModelWithImageName:@"tabbar_compose_more"
                                   highlightImageName:nil
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        MUIPopMenuModel* model7 = [MUIPopMenuModel
                                   popMenuModelWithImageName:@"tabbar_compose_more"
                                   highlightImageName:nil
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        MUIPopMenuModel* model8 = [MUIPopMenuModel
                                   popMenuModelWithImageName:@"tabbar_compose_more"
                                   highlightImageName:nil
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        MUIPopMenuModel* model9 = [MUIPopMenuModel
                                   popMenuModelWithImageName:@"tabbar_compose_more"
                                   highlightImageName:nil
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        MUIPopMenuModel* model10 = [MUIPopMenuModel
                                    popMenuModelWithImageName:@"tabbar_compose_more"
                                    highlightImageName:nil
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        MUIPopMenuModel* model11 = [MUIPopMenuModel
                                    popMenuModelWithImageName:@"tabbar_compose_idea"
                                    highlightImageName:nil
                                  titleString:@"文字/头条"
                                  transitionType:MUIPopMenuTransitionTypeCustomizeApi
                                  transitionRenderingColor:nil];
        
        MUIPopMenuModel* model12 = [MUIPopMenuModel
                                    popMenuModelWithImageName:@"tabbar_compose_photo"
                                    highlightImageName:nil
                                   titleString:@"相册/视频"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        
        MUIPopMenuModel* model13 = [MUIPopMenuModel
                                    popMenuModelWithImageName:@"tabbar_compose_camera"
                                    highlightImageName:nil
                                   titleString:@"拍摄/短视频"
                                   transitionType:MUIPopMenuTransitionTypeCustomizeApi
                                   transitionRenderingColor:nil];
        
        MUIPopMenuModel* model14 = [MUIPopMenuModel
                                    popMenuModelWithImageName:@"tabbar_compose_lbs"
                                    highlightImageName:nil
                                   titleString:@"签到"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        
        MUIPopMenuModel* model15 = [MUIPopMenuModel
                                    popMenuModelWithImageName:@"tabbar_compose_review"
                                    highlightImageName:nil
                                   titleString:@"点评"
                                   transitionType:MUIPopMenuTransitionTypeCustomizeApi
                                   transitionRenderingColor:nil];
        MUIPopMenuModel* model16 = [MUIPopMenuModel
                                    popMenuModelWithImageName:@"tabbar_compose_more"
                                    highlightImageName:nil
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        MUIPopMenuModel* model17 = [MUIPopMenuModel
                                    popMenuModelWithImageName:@"tabbar_compose_more"
                                    highlightImageName:nil
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        MUIPopMenuModel* model18 = [MUIPopMenuModel
                                    popMenuModelWithImageName:@"tabbar_compose_more"
                                    highlightImageName:nil
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        MUIPopMenuModel* model19 = [MUIPopMenuModel
                                    popMenuModelWithImageName:@"tabbar_compose_more"
                                    highlightImageName:nil
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeSystemApi
                                   transitionRenderingColor:nil];
        MUIPopMenuModel* model20 = [MUIPopMenuModel
                                    popMenuModelWithImageName:@"tabbar_compose_more"
                                    highlightImageName:nil
                                    titleString:@"更多"                                    transitionType:MUIPopMenuTransitionTypeSystemApi
                                    transitionRenderingColor:nil];
        
        _dataArr = @[model, model1, model2, model3, model4, model5, model6, model7, model8, model9, model10, model11, model12, model13, model14, model15, model16, model17, model18, model19, model20];
    }
    return _dataArr;
}
@end
