//
//  ZADisplay.h
//  Common
//
//  Created by lgb789 on 2017/3/13.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZADisplay : NSObject

/**
 中间显示view

 @param view 要显示的view
 @param controller 在viewcontroller中显示
 @param lightBackground 背景是否透明
 @param blurBackground 背景是否模糊
 @param shrinkBackground 背景是否缩小
 @param tap 背景点击事件
 */
+(void)displayView:(UIView *)view centerInViewController:(UIViewController *)controller lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground backgroundTap:(void(^)(void))tap;

/**
 顶部显示view

 @param view 要显示的view
 @param controller 在viewcontroller中显示
 @param lightBackground 背景是否透明
 @param blurBackground 背景是否模糊
 @param shrinkBackground 背景是否缩小
 @param tap 背景点击事件
 */
+(void)displayView:(UIView *)view topInViewController:(UIViewController *)controller lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground backgroundTap:(void(^)(void))tap;

/**
 底部显示view

 @param view 要显示的view
 @param controller 在viewcontroller中显示
 @param lightBackground 背景是否透明
 @param blurBackground 背景是否模糊
 @param shrinkBackground 背景是否缩小
 @param tap 背景点击事件
 */
+(void)displayView:(UIView *)view bottomInViewController:(UIViewController *)controller lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground backgroundTap:(void(^)(void))tap;

/**
 左边显示view

 @param view 要显示的view
 @param controller 在viewcontroller中显示
 @param lightBackground 背景是否透明
 @param blurBackground 背景是否模糊
 @param shrinkBackground 背景是否缩小
 @param tap 背景点击事件
 */
+(void)displayView:(UIView *)view leftInViewController:(UIViewController *)controller lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground backgroundTap:(void(^)(void))tap;

/**
 右边显示view

 @param view 要显示的view
 @param controller 在viewcontroller中显示
 @param lightBackground 背景是否透明
 @param blurBackground 背景是否模糊
 @param shrinkBackground 背景是否缩小
 @param tap 背景点击事件
 */
+(void)displayView:(UIView *)view rightInViewController:(UIViewController *)controller lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground backgroundTap:(void(^)(void))tap;

/**
 清除view

 @param view 要清除的view
 @param animated 是否动画
 @param duration 动画时间
 */
+(void)dismissView:(UIView *)view animated:(BOOL)animated duration:(CGFloat)duration;

/**
 显示view，如果view有父view，则放大显示，否则正常居中显示

 @param view 要显示的view
 @param controller 在viewcontroller中显示
 @param lightBackground 背景是否透明
 @param blurBackground 背景是否模糊
 @param shrinkBackground 背景是否缩小
 @param dimiss view清除事件
 */
+(void)displayView:(UIView *)view inViewController:(UIViewController *)controller lightBackground:(BOOL)lightBackground blurBackground:(BOOL)blurBackground shrinkBackground:(BOOL)shrinkBackground dismiss:(void(^)(void))dimiss;

@end
