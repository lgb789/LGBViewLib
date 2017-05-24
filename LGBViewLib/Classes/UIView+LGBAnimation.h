//
//  UIView+LGBAnimation.h
//  AnimationCategory
//
//  Created by lgb789 on 2017/2/21.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    //弹跳
    LGBAnimationTypeBounceLeft,
    LGBAnimationTypeBounceRight,
    LGBAnimationTypeBounceDown,
    LGBAnimationTypeBounceUp,
    //淡入淡出
    LGBAnimationTypeFadeIn,
    LGBAnimationTypeFadeOut,
    LGBAnimationTypeFadeInSemi,
    LGBAnimationTypeFadeOutSemi,
    LGBAnimationTypeFadeInLeft,
    LGBAnimationTypeFadeInRight,
    LGBAnimationTypeFadeInDown,
    LGBAnimationTypeFadeInUp,
    LGBAnimationTypeFadeOutLeft,
    LGBAnimationTypeFadeOutRight,
    LGBAnimationTypeFadeOutDown,
    LGBAnimationTypeFadeOutUp,
    //滑动
    LGBAnimationTypeSlideLeft,
    LGBAnimationTypeSlideRight,
    LGBAnimationTypeSlideDown,
    LGBAnimationTypeSlideUp,
    LGBAnimationTypeSlideLeftReverse,
    LGBAnimationTypeSlideRightReverse,
    LGBAnimationTypeSlideDownReverse,
    LGBAnimationTypeSlideUpReverse,
    //跳动
    LGBAnimationTypePop,
    LGBAnimationTypePopAlphaIn,
    LGBAnimationTypePopAlphaOut,
    //变形
    LGBAnimationTypeMorph,
    //闪烁
    LGBAnimationTypeFlash,
    //颤动
    LGBAnimationTypeShake,
    //缩放
    LGBAnimationTypeZoomIn,
    LGBAnimationTypeZoomOut,
    LGBAnimationTypePopDown,
    LGBAnimationTypePopUp,
    LGBAnimationTypePopAlphaUp,
    
} LGBAnimationType;

@interface UIView (LGBAnimation)

/**
 移除动画
 */
-(void)lgb_RemoveAnimation;

/**
 开始执行动画
 */
-(void)lgb_StartAnimationComplete:(void(^)(void))complete;

/**
 移除所有子视图动画
 */
-(void)lgb_RemoveCanvasAnimation;

/**
 执行所有子视图动画
 */
-(void)lgb_StartCanvasAnimation;

/**
 添加动画到视图
   
 如果要执行动画，需要执行lgb_StartAnimation或者lgb_StartCanvasAnimation方法
 @param type 动画类型
 @param delay 延时执行时间
 @param duration 动画持续时间
 */
-(void)lgb_AddAnimationType:(LGBAnimationType)type delay:(CGFloat)delay duration:(CGFloat)duration;

@end
