# MUIPopMenu 

## 功能简介

#### 九宫格动画控件是一个在手机上查看多个选项的UI控件，它支持以下功能
* 从点击出弹出按钮视图 

#### Demo
![Dome](https://github.com/hua16/MUIPopMenu/blob/master/%E5%8A%A8%E7%94%BB%E6%95%88%E6%9E%9C.gif)

## 安装说明

### 添加依赖

- 组件`podspec`文件添加s.dependency 'MUIPopMenu'
- 组件`Podfile`文件添加pod 'MUIPopMenu'

### 本控件依赖

- pop
- Masonry
- APFKit
- MUPFoundationProfiler 

## 使用说明

### 数据模型

- `MUIMultiPhotoController`初始化，数据模型接收一个构造好的`dataArr`数组

```objc
    MUIPopMenuView menu = [MUIPopMenuView shareInstance];
    menu.delegate = self;
    menu.popMenuSpeed = 12.0f;
    menu.animationType = MUIPopMenuViewAnimationTypeViscous;
    menu.dataSource = self.dataArr;
```

- `dataArr`数组由`MUIPopMenuModel`对象组成：

```objc
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

```

### 使用范例 

- 初始化MUIPopMenuView对象，传入构造好的`MUIPopMenuModel`数组

```objc

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

```
 
### 主要接口
- 单例

    ` + (instancetype)shareInstance;`     

- 显示菜单视图

    ` - (void)showMenu; `

- 隐藏菜单视图

    ` - (void)hideMenu; `

- 判断菜单是否打开

    `- (BOOL)isOpenMenu;`

### 代理

- 按钮点击事件

    ` - (void)popMenuView:(MUIPopMenuView*)popMenuView didSelectItemAtIndex:(NSUInteger)index;` 
    
### 属性

```objc
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
```









