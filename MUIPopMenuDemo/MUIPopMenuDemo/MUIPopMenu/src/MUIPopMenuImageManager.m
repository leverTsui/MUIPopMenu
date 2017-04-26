//
//  UIModuleHelper.m
//  UIModule
//
//  Created by devp on 5/12/15.
//  Copyright (c) 2015 ND. All rights reserved.
//

#import "MUIPopMenuImageManager.h"
#import "MUIPopMenuMacro.h"

@interface MUIPopMenuImageManager ()


@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, copy) NSString *bundleImageName;

@end

@implementation MUIPopMenuImageManager

+ (MUIPopMenuImageManager *)instance; {
    static MUIPopMenuImageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MUIPopMenuImageManager alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _imageCache = [[NSCache alloc] init];
    }
    
    return self;
}

- (UIImage *)imageNamed:(NSString*)imageName {
    NSString *bundleImageName = MUIPopMenu_bdlRes(imageName);
    UIImage *retImage = [self.imageCache objectForKey:bundleImageName];
    if (retImage) {
        return retImage;
    }
    retImage = [UIImage imageNamed:bundleImageName];
    if (retImage) {
        [self.imageCache setObject:retImage forKey:bundleImageName];
        return retImage;
    }
    
    return nil;
}
@end
