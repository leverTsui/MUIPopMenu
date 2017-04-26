//
//  ViewController.m
//  MUIPopMenuDemo
//
//  Created by xulihua on 2017/4/25.
//  Copyright © 2017年 huage. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "MUIPopMenu.h"

@interface ViewController ()<MUIPopMenuViewDelegate>

@property (nonatomic, strong) MUIPopMenuView* menu;
@property (nonatomic, strong) UIImageView *backgroudIV;
@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIButton *middleButton;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) NSInteger random;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

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
    [self.backgroudIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(40);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(49);
    }];
    [self.middleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(100);;
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(49);
    }];
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
            self.menu.animationType = MUIPopMenuViewAnimationTypeSina;
        }
            break;
        case 1002: {
            self.menu.animationType = MUIPopMenuViewAnimationTypeViscous;
        }
            break;
            
        default:
            break;
    }
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.dataArr];
    //    [mutableArr addObjectsFromArray:[self.dataArr copy]];
    self.menu.dataSource = [mutableArr copy];
    //    self.menu.dataSource = self.dataArr;
    
    self.random += 1;
    if (self.random > self.menu.dataSource.count) {
        self.random = 0;
    }
    //        self.random = 1;
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
        _menu.animationType = MUIPopMenuViewAnimationTypeViscous;
    }
    return _menu;
}

- (UIButton *)topButton {
    if (!_topButton) {
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _topButton.titleLabel.textColor = [UIColor whiteColor];
        [_topButton setTitle:@"顶部按钮" forState:UIControlStateNormal];
        [_topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _topButton.tag = 1000;
        [_topButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topButton;
}

- (UIButton *)middleButton {
    if (!_middleButton) {
        _middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _middleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _middleButton.titleLabel.textColor = [UIColor whiteColor];
        [_middleButton setTitle:@"中间按钮" forState:UIControlStateNormal];
        [_middleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
        [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
        MUIPopMenuModel* model = [MUIPopMenuModel
                                  popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_idea"]
                                  titleString:@"文字/头条"
                                  transitionType:MUIPopMenuTransitionTypeDefault
                                  buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                      
                                  }];
        
        
        
        MUIPopMenuModel* model1 = [MUIPopMenuModel
                                   popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_photo"]
                                   titleString:@"相册/视频"
                                   transitionType:MUIPopMenuTransitionTypeDefault
                                   buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                       
                                   }];
        
        MUIPopMenuModel* model2 = [MUIPopMenuModel
                                   popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_camera"]
                                   titleString:@"拍摄/短视频"                                   transitionType:MUIPopMenuTransitionTypeDefault   buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                       
                                   }];
        
        MUIPopMenuModel* model3 = [MUIPopMenuModel
                                   popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_lbs"]
                                   titleString:@"签到"
                                   transitionType:MUIPopMenuTransitionTypeDefault   buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                       
                                   }];
        
        MUIPopMenuModel* model4 = [MUIPopMenuModel
                                   popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_review"]
                                   titleString:@"点评"
                                   transitionType:MUIPopMenuTransitionTypeDefault   buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                       
                                   }];
        MUIPopMenuModel* model5 = [MUIPopMenuModel
                                   popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_more"]
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeDefault
                                   buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                       
                                   }];
        MUIPopMenuModel* model6 = [MUIPopMenuModel
                                   popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_more"]
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeDefault
                                   buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                       
                                   }];
        MUIPopMenuModel* model7 = [MUIPopMenuModel
                                   popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_more"]
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeDefault
                                   buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                       
                                   }];
        
        MUIPopMenuModel* model8 = [MUIPopMenuModel
                                   popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_more"]
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeDefault
                                   buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                       
                                   }];
        
        MUIPopMenuModel* model9 = [MUIPopMenuModel
                                   popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_more"]
                                   titleString:@"更多"
                                   transitionType:MUIPopMenuTransitionTypeDefault
                                   buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                       
                                   }];
        
        MUIPopMenuModel* model10 = [MUIPopMenuModel
                                    popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_more"]
                                    titleString:@"更多"
                                    transitionType:MUIPopMenuTransitionTypeDefault
                                    buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                        
                                    }];
        
        MUIPopMenuModel* model11 = [MUIPopMenuModel
                                    popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_idea"]
                                    titleString:@"文字/头条"
                                    transitionType:MUIPopMenuTransitionTypeDefault
                                    buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                        
                                    }];
        
        MUIPopMenuModel* model12 = [MUIPopMenuModel
                                    popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_photo"]
                                    titleString:@"相册/视频"
                                    transitionType:MUIPopMenuTransitionTypeSystemApi
                                    buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                        
                                    }];
        
        MUIPopMenuModel* model13 = [MUIPopMenuModel
                                    popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_camera"]
                                    titleString:@"拍摄/短视频"
                                    transitionType:MUIPopMenuTransitionTypeCustomizeApi
                                    buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                        
                                    }];
        
        MUIPopMenuModel* model14 = [MUIPopMenuModel
                                    popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_lbs"]
                                    titleString:@"签到"
                                    transitionType:MUIPopMenuTransitionTypeSystemApi
                                    buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                        
                                    }];
        
        MUIPopMenuModel* model15 = [MUIPopMenuModel
                                    popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_review"]
                                    titleString:@"点评"
                                    transitionType:MUIPopMenuTransitionTypeDefault
                                    buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                        
                                    }];
        
        MUIPopMenuModel* model16 = [MUIPopMenuModel
                                    popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_more"]
                                    titleString:@"更多"
                                    transitionType:MUIPopMenuTransitionTypeSystemApi
                                    buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                        
                                    }];
        
        MUIPopMenuModel* model17 = [MUIPopMenuModel
                                    popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_more"]
                                    titleString:@"更多"
                                    transitionType:MUIPopMenuTransitionTypeDefault
                                    buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                        
                                    }];
        
        MUIPopMenuModel* model18 = [MUIPopMenuModel
                                    popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_more"]
                                    titleString:@"更多"
                                    transitionType:MUIPopMenuTransitionTypeDefault
                                    buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                        
                                    }];
        
        MUIPopMenuModel* model19 = [MUIPopMenuModel
                                    popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_more"]
                                    titleString:@"更多"
                                    transitionType:MUIPopMenuTransitionTypeDefault
                                    buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                        
                                    }];
        
        MUIPopMenuModel* model20 = [MUIPopMenuModel
                                    popMenuModelWithImage:[UIImage imageNamed:@"tabbar_compose_more"]
                                    titleString:@"更多"
                                    transitionType:MUIPopMenuTransitionTypeDefault
                                    buttonClickBlock:^(MUIPopMenuModel *popMenuModel, NSUInteger index) {
                                        
                                    }];
        
        
        _dataArr = @[model, model1, model2, model3, model4, model5, model6, model7, model8, model9, model10, model11, model12, model13, model14, model15, model16, model17, model18, model19, model20];
    }
    return _dataArr;
}

@end
