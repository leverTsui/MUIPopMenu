//
//  MUIPopMenuMacro.h
//  MUIPopMenu
//
//  Created by xulihua on 2017/1/12.
//  Copyright © 2017年 ND. All rights reserved.
//
#ifndef MUIPopMenuMacro_h
#define MUIPopMenuMacro_h


//static inline void MUPLogError(NSString *format, ...) {
//    #ifdef DEBUG
//        va_list argptr;
//        va_start(argptr, format);
//        NSLogv(format, argptr);
//        va_end(argptr);
//    #endif
//}

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif



#define MUIPopMenuDuration 0.5
#define MUIPopMenuKeyPath @"transform.scale"
#define MUIPopMenuScreenWidth [UIScreen mainScreen].bounds.size.width
#define MUIPopMenuScreenHeight [UIScreen mainScreen].bounds.size.height

#define MUIPopMenu_bdlRes(name) [NSString stringWithFormat:@"MUIPopMenuBundle.bundle/%@",name]

//#define MUIPopMenuSkin_FONT_KEY_8  [APFSkin fontWithKey:@"character_8"]
//#define MUIPopMenuSkin_COLOR_KEY_2  [APFSkin colorWithKey:@"color_2"]
#define MUIPopMenuSkin_FONT_KEY_8 [UIFont systemFontOfSize:10]
#define MUIPopMenuSkin_COLOR_KEY_2 [UIColor grayColor]
#define kSystemVersion [UIDevice currentDevice].systemVersion.doubleValue


#define kiOS6Later (kSystemVersion >= 6)
#define kiOS7Later (kSystemVersion >= 7)
#define kiOS8Later (kSystemVersion >= 8)
#define kiOS9Later (kSystemVersion >= 9)


//#define kMUIPopMenuButtonViewH  (56+MUIPopMenuSkin_FONT_KEY_8.pointSize)
#define kMUIPopMenuButtonViewH  (56+14)

#define kMUIPopMenuButtonViewW  70

#define kMUIPopMenuButtonViewMarginX  13
#define kMUIPopMenuButtonViewMarginY  18

#endif /* MUIPopMenuMacro_h */
