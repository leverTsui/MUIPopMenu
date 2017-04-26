//
//  UIModuleHelper.h
//  UIModule
//
//  Created by devp on 5/12/15.
//  Copyright (c) 2015 ND. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MUIPopMenuImageManager : NSObject

+ (MUIPopMenuImageManager *)instance;

- (UIImage *)imageNamed:(NSString*)imageName;
@end
