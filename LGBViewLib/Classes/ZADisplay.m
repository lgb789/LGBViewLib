//
//  ZADisplay.m
//  Common
//
//  Created by lgb789 on 2017/3/13.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import "ZADisplay.h"
#import "ZADisplayController.h"

@implementation ZADisplay

static NSMutableDictionary *__displayDictionary;

#pragma mark - 成员变量创建

#pragma mark - 初始化
+(void)load
{
    __displayDictionary = [NSMutableDictionary dictionary];
}

#pragma mark - 代理

#pragma mark - 事件处理 

#pragma mark - 私有方法

#pragma mark - 公有方法

+(void)displayView:(UIView *)view inViewController:(UIViewController *)controller position:(ZADisplayViewPosition)position lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground backgroundTap:(void(^)(void))tap
{
    ZADisplayController *displayController = [ZADisplayController new];
    displayController.tapBackground = tap;
    displayController.maskType = lightBackground ? ZADisplayMaskTypeLight : ZADisplayMaskTypeDark;
    displayController.blur = blurBackground;
    displayController.shrink = shrinkBackground;
    [displayController displayView:view inViewController:controller position:position];
    
    if (tap) {
        [__displayDictionary setObject:displayController forKey:[NSValue valueWithNonretainedObject:view]];
    }
    
}

+(void)displayView:(UIView *)view centerInViewController:(UIViewController *)controller lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground backgroundTap:(void(^)(void))tap
{
    [[self class] displayView:view inViewController:controller position:ZADisplayViewPositionCenter lightBackground:lightBackground blurBackground:blurBackground shrinkBackground:shrinkBackground backgroundTap:tap];
}

+(void)displayView:(UIView *)view topInViewController:(UIViewController *)controller lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground backgroundTap:(void(^)(void))tap
{
    [[self class] displayView:view inViewController:controller position:ZADisplayViewPositionTop lightBackground:lightBackground blurBackground:blurBackground shrinkBackground:shrinkBackground backgroundTap:tap];
}

+(void)displayView:(UIView *)view bottomInViewController:(UIViewController *)controller lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground backgroundTap:(void(^)(void))tap
{
    [[self class] displayView:view inViewController:controller position:ZADisplayViewPositionBottom lightBackground:lightBackground blurBackground:blurBackground shrinkBackground:shrinkBackground backgroundTap:tap];
}

+(void)displayView:(UIView *)view leftInViewController:(UIViewController *)controller lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground backgroundTap:(void(^)(void))tap
{
    [[self class] displayView:view inViewController:controller position:ZADisplayViewPositionLeft lightBackground:lightBackground blurBackground:blurBackground shrinkBackground:shrinkBackground backgroundTap:tap];
}

+(void)displayView:(UIView *)view rightInViewController:(UIViewController *)controller lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground backgroundTap:(void(^)(void))tap
{
    [[self class] displayView:view inViewController:controller position:ZADisplayViewPositionRight lightBackground:lightBackground blurBackground:blurBackground shrinkBackground:shrinkBackground backgroundTap:tap];
}

+(void)dismissView:(UIView *)view animated:(BOOL)animated duration:(CGFloat)duration
{
    
    NSValue *key = [NSValue valueWithNonretainedObject:view];
    ZADisplayController *displayController = [__displayDictionary objectForKey:key];
    if (displayController) {
        [__displayDictionary removeObjectForKey:key];
        [displayController dismissFromParentAnimated:animated duration:duration];
    }
    
}

+(void)displayView:(UIView *)view inViewController:(UIViewController *)controller lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground dismiss:(void(^)(void))dimiss
{
    ZADisplayController *displayController = [ZADisplayController new];
    displayController.tapBackground = dimiss;
    displayController.maskType = lightBackground ? ZADisplayMaskTypeLight : ZADisplayMaskTypeDark;
    displayController.blur = blurBackground;
    displayController.shrink = shrinkBackground;
    [displayController displayView:view inViewController:controller];
    
    if (dimiss) {
        [__displayDictionary setObject:displayController forKey:[NSValue valueWithNonretainedObject:view]];
    }
}

@end
