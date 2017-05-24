//
//  UIView+LGBAnimation.m
//  AnimationCategory
//
//  Created by lgb789 on 2017/2/21.
//  Copyright © 2017年 com.dnj. All rights reserved.
//
#import <objc/runtime.h>
#import "UIView+LGBAnimation.h"

static void *kType;
static void *kDelay;
static void *kDuration;


@implementation UIView (LGBAnimation)
//Zoom
-(void)lgb_PerformZoomAnimationType:(LGBAnimationType)type delay:(CGFloat)delay duration:(CGFloat)duration complete:(void(^)(void))complete
{
    NSArray *alphaArray = nil;
    NSArray *xArray = nil;
    NSArray *yArray = nil;
    switch (type) {
        case LGBAnimationTypeZoomIn:
            alphaArray = @[@1, @0];
            xArray = @[@1, @2];
            yArray = @[@1, @2];
            break;
        case LGBAnimationTypeZoomOut:
            alphaArray = @[@0, @1];
            xArray = @[@2, @1];
            yArray = @[@2, @1];
            break;
            
        default:
            break;
    }
    self.alpha = [alphaArray[0] floatValue];
    self.transform = CGAffineTransformMakeScale([xArray[0] floatValue], [yArray[0] floatValue]);
    
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        self.transform = CGAffineTransformMakeScale([xArray[1] floatValue], [yArray[1] floatValue]);
        self.alpha = [alphaArray[1] floatValue];
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

//Shake
-(void)lgb_PerformShakeAnimationType:(LGBAnimationType)type delay:(CGFloat)delay duration:(CGFloat)duration complete:(void(^)(void))complete
{
    self.transform = CGAffineTransformMakeTranslation(0, 0);
    [UIView animateKeyframesWithDuration:duration / 5 delay:delay options:0 animations:^{
        self.transform = CGAffineTransformMakeTranslation(30, 0);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration / 5 delay:0 options:0 animations:^{
            self.transform = CGAffineTransformMakeTranslation(-30, 0);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration / 5 delay:0 options:0 animations:^{
                self.transform = CGAffineTransformMakeTranslation(15, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:duration / 5 delay:0 options:0 animations:^{
                    self.transform = CGAffineTransformMakeTranslation(-15, 0);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:duration / 5 delay:0 options:0 animations:^{
                        self.transform = CGAffineTransformMakeTranslation(0, 0);
                    } completion:^(BOOL finished) {
                        if (complete) {
                            complete();
                        }
                    }];
                }];
            }];
        }];
    }];
}

//Flash
-(void)lgb_PerformFlashAnimationType:(LGBAnimationType)type delay:(CGFloat)delay duration:(CGFloat)duration complete:(void(^)(void))complete
{
    self.alpha = 0;
    [UIView animateKeyframesWithDuration:duration / 3 delay:delay options:0 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration / 3 delay:0 options:0 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration / 3 delay:0 options:0 animations:^{
                self.alpha = 1;
            } completion:^(BOOL finished) {
                if (complete) {
                    complete();
                }
            }];
        }];
    }];
}

//Morph
-(void)lgb_PerformMorphAnimationType:(LGBAnimationType)type delay:(CGFloat)delay duration:(CGFloat)duration complete:(void(^)(void))complete
{
    self.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateKeyframesWithDuration:duration / 4 delay:delay options:0 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration / 4 delay:0 options:0 animations:^{
            self.transform = CGAffineTransformMakeScale(1.2, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration / 4 delay:0 options:0 animations:^{
                self.transform = CGAffineTransformMakeScale(0.9, 0.9);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:duration / 4 delay:0 options:0 animations:^{
                    self.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    if (complete) {
                        complete();
                    }
                }];
            }];
        }];
    }];
}

//Pop
-(void)lgb_PerformPopAnimationType:(LGBAnimationType)type delay:(CGFloat)delay duration:(CGFloat)duration complete:(void(^)(void))complete
{
    NSArray *xArray = nil;
    NSArray *yArray = nil;
    NSArray *alphaArray = nil;
    switch (type) {
        case LGBAnimationTypePopDown:
            xArray = @[@1, @(0.9)];
            yArray = @[@1, @(0.9)];
            alphaArray = @[@1, @1];
            break;
        case LGBAnimationTypePopUp:
            xArray = @[@(0.9), @1];
            yArray = @[@(0.9), @1];
            alphaArray = @[@1, @1];
            break;
        case LGBAnimationTypePopAlphaUp:
            xArray = @[@(0.9), @1.2];
            yArray = @[@(0.9), @1.2];
            alphaArray = @[@1, @0];
            duration = duration / 3;
            break;
        default:
            break;
    }
    
    self.alpha = [alphaArray[0] floatValue];
    self.transform = CGAffineTransformMakeScale([xArray[0] floatValue], [yArray[0] floatValue]);
    
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        self.alpha = [alphaArray[1] floatValue];
        self.transform = CGAffineTransformMakeScale([xArray[1] floatValue], [yArray[1] floatValue]);
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

-(void)lgb_PerformPopAlphaAnimationType:(LGBAnimationType)type delay:(CGFloat)delay duration:(CGFloat)duration complete:(void(^)(void))complete
{
    NSArray *alphaArray = nil;
    NSArray *xArray = nil;
    NSArray *yArray = nil;
    switch (type) {
        case LGBAnimationTypePop:
            xArray = @[@1, @1.2, @0.9, @1];
            yArray = @[@1, @1.2, @0.9, @1];
            alphaArray = @[@1, @1, @1, @1];
            break;
        case LGBAnimationTypePopAlphaIn:
            xArray = @[@1, @1.2, @0.9, @1];
            yArray = @[@1, @1.2, @0.9, @1];
            alphaArray = @[@0, @1, @1, @1];
            break;
        case LGBAnimationTypePopAlphaOut:
            xArray = @[@1, @0.9, @1.2, @1];
            yArray = @[@1, @0.9, @1.2, @1];
            alphaArray = @[@1, @1, @1, @0];
            break;
        default:
            break;
    }
    __block NSInteger index = 0;
    self.alpha = [alphaArray[index] floatValue];
    self.transform = CGAffineTransformMakeScale([xArray[index] floatValue], [yArray[index] floatValue]);
    
    [UIView animateKeyframesWithDuration:duration / 3 delay:0 options:0 animations:^{
        index++;
        self.transform = CGAffineTransformMakeScale([xArray[index] floatValue], [yArray[index] floatValue]);
        self.alpha = [alphaArray[index] floatValue];
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration / 3 delay:0 options:0 animations:^{
            index++;
            self.transform = CGAffineTransformMakeScale([xArray[index] floatValue], [yArray[index] floatValue]);
            self.alpha = [alphaArray[index] floatValue];
        } completion:^(BOOL finished) {
            index++;
            [UIView animateKeyframesWithDuration:duration / 3 delay:0 options:0 animations:^{
                self.transform = CGAffineTransformMakeScale([xArray[index] floatValue], [yArray[index] floatValue]);
                self.alpha = [alphaArray[index] floatValue];
            } completion:^(BOOL finished) {
                if (complete) {
                    complete();
                }
            }];
        }];
    }];
}

//Slide
-(void)lgb_PerformSlideAnimationType:(LGBAnimationType)type delay:(CGFloat)delay duration:(CGFloat)duration complete:(void(^)(void))complete
{
    NSArray *xArray = nil;
    NSArray *yArray = nil;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    switch (type) {
        case LGBAnimationTypeSlideLeft:
            xArray = @[@(screenWidth), @0];
            yArray = @[@0, @0];
            break;
        case LGBAnimationTypeSlideRight:
            xArray = @[@(-screenWidth), @0];
            yArray = @[@0, @0];
            break;
        case LGBAnimationTypeSlideDown:
            xArray = @[@0, @0];
            yArray = @[@(-screenHeight), @0];
            break;
        case LGBAnimationTypeSlideUp:
            xArray = @[@0, @0];
            yArray = @[@(screenHeight), @0];
            break;
        case LGBAnimationTypeSlideLeftReverse:
            xArray = @[@0, @(screenWidth)];
            yArray = @[@0, @0];
            break;
        case LGBAnimationTypeSlideRightReverse:
            xArray = @[@0, @(-screenWidth)];
            yArray = @[@0, @0];
            break;
        case LGBAnimationTypeSlideDownReverse:
            xArray = @[@0, @0];
            yArray = @[@0, @(-screenHeight)];
            break;
        case LGBAnimationTypeSlideUpReverse:
            xArray = @[@0, @0];
            yArray = @[@0, @(screenHeight)];
            break;
        default:
            break;
    }
    
    self.transform = CGAffineTransformMakeTranslation([xArray[0] floatValue], [yArray[0] floatValue]);
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        self.transform = CGAffineTransformMakeTranslation([xArray[1] floatValue], [yArray[1] floatValue]);
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

//Fade
-(void)lgb_PerformFadeAnimationType:(LGBAnimationType)type delay:(CGFloat)delay duration:(CGFloat)duration complete:(void(^)(void))complete
{
    NSArray *alphaArray = nil;
    NSArray *xArray = nil;
    NSArray *yArray = nil;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    switch (type) {
        case LGBAnimationTypeFadeIn:
            alphaArray = @[@0, @1];
            xArray = @[@0, @0];
            yArray = @[@0, @0];
            break;
        case LGBAnimationTypeFadeOut:
            alphaArray = @[@1, @0];
            xArray = @[@0, @0];
            yArray = @[@0, @0];
            break;
        case LGBAnimationTypeFadeInSemi:
            alphaArray = @[@0, @(0.4)];
            xArray = @[@0, @0];
            yArray = @[@0, @0];
            break;
        case LGBAnimationTypeFadeOutSemi:
            alphaArray = @[@(0.4), @0];
            xArray = @[@0, @0];
            yArray = @[@0, @0];
            break;
        case LGBAnimationTypeFadeInLeft:
            alphaArray = @[@0, @1];
            xArray = @[@(screenWidth), @0];
            yArray = @[@0, @0];
            break;
        case LGBAnimationTypeFadeInRight:
            alphaArray = @[@0, @1];
            xArray = @[@(-screenWidth), @0];
            yArray = @[@0, @0];
            break;
        case LGBAnimationTypeFadeInDown:
            alphaArray = @[@0, @1];
            xArray = @[@0, @0];
            yArray = @[@(-screenHeight), @0];
            break;
        case LGBAnimationTypeFadeInUp:
            alphaArray = @[@0, @1];
            xArray = @[@0, @0];
            yArray = @[@(screenHeight), @0];
            break;
        case LGBAnimationTypeFadeOutLeft:
            alphaArray = @[@1, @0];
            xArray = @[@0, @(screenWidth)];
            yArray = @[@0, @0];
            break;
        case LGBAnimationTypeFadeOutRight:
            alphaArray = @[@1, @0];
            xArray = @[@0, @(-screenWidth)];
            yArray = @[@0, @0];
            break;
        case LGBAnimationTypeFadeOutDown:
            alphaArray = @[@1, @0];
            xArray = @[@0, @0];
            yArray = @[@0, @(-screenHeight)];
            break;
        case LGBAnimationTypeFadeOutUp:
            alphaArray = @[@1, @0];
            xArray = @[@0, @0];
            yArray = @[@0, @(screenHeight)];
            break;
        default:
            break;
    }
    
    self.transform = CGAffineTransformMakeTranslation([xArray[0] floatValue], [yArray[0] floatValue]);
    self.alpha = [alphaArray[0] floatValue];
    
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        self.transform = CGAffineTransformMakeTranslation([xArray[1] floatValue], [yArray[1] floatValue]);
        self.alpha = [alphaArray[1] floatValue];
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

//Bounce
-(void)lgb_PerformBounceAnimationType:(LGBAnimationType)type delay:(CGFloat)delay duration:(CGFloat)duration complete:(void(^)(void))complete
{
    NSArray *xArray = nil;
    NSArray *yArray = nil;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    switch (type) {
        case LGBAnimationTypeBounceLeft:
            xArray = @[@(screenWidth), @(-10), @(5), @(-2), @0];
            yArray = @[@0, @0, @0, @0, @0];
            break;
        case LGBAnimationTypeBounceRight:
            xArray = @[@(-screenWidth), @(10), @(-5), @(2), @0];
            yArray = @[@0, @0, @0, @0, @0];
            break;
        case LGBAnimationTypeBounceDown:
            xArray = @[@0, @0, @0, @0, @0];
            yArray = @[@(-screenHeight), @(10), @(-5), @(2), @0];
            break;
        case LGBAnimationTypeBounceUp:
            xArray = @[@0, @0, @0, @0, @0];
            yArray = @[@(screenHeight), @(-10), @(5), @(-2), @0];
            break;
            
        default:
            break;
    }
    
    __block NSInteger index = 0;
    
    self.transform = CGAffineTransformMakeTranslation([xArray[index] floatValue], [yArray[index] floatValue]);
    
    [UIView animateKeyframesWithDuration:duration / 4 delay:delay options:0 animations:^{
        index++;
        self.transform = CGAffineTransformMakeTranslation([xArray[index] floatValue], [yArray[index] floatValue]);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration / 4 delay:0 options:0 animations:^{
            index++;
            self.transform = CGAffineTransformMakeTranslation([xArray[index] floatValue], [yArray[index] floatValue]);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration / 4 delay:0 options:0 animations:^{
                index++;
                self.transform = CGAffineTransformMakeTranslation([xArray[index] floatValue], [yArray[index] floatValue]);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:duration / 4 delay:0 options:0 animations:^{
                    index++;
                    self.transform = CGAffineTransformMakeTranslation([xArray[index] floatValue], [yArray[index] floatValue]);
                } completion:^(BOOL finished) {
                    if (complete) {
                        complete();
                    }
                }];
            }];
        }];
    }];
}

-(void)lgb_PerformAnimationType:(LGBAnimationType)type delay:(CGFloat)delay duration:(CGFloat)duration complete:(void(^)(void))complete
{
    switch (type) {
        case LGBAnimationTypeBounceLeft:
        case LGBAnimationTypeBounceRight:
        case LGBAnimationTypeBounceDown:
        case LGBAnimationTypeBounceUp:
            [self lgb_PerformBounceAnimationType:type delay:delay duration:duration complete:complete];
            break;
        case LGBAnimationTypeFadeIn:
        case LGBAnimationTypeFadeOut:
        case LGBAnimationTypeFadeInSemi:
        case LGBAnimationTypeFadeOutSemi:
        case LGBAnimationTypeFadeInLeft:
        case LGBAnimationTypeFadeInRight:
        case LGBAnimationTypeFadeInDown:
        case LGBAnimationTypeFadeInUp:
        case LGBAnimationTypeFadeOutLeft:
        case LGBAnimationTypeFadeOutRight:
        case LGBAnimationTypeFadeOutDown:
        case LGBAnimationTypeFadeOutUp:
            [self lgb_PerformFadeAnimationType:type delay:delay duration:duration complete:complete];
            break;
        case LGBAnimationTypeSlideLeft:
        case LGBAnimationTypeSlideRight:
        case LGBAnimationTypeSlideDown:
        case LGBAnimationTypeSlideUp:
        case LGBAnimationTypeSlideLeftReverse:
        case LGBAnimationTypeSlideRightReverse:
        case LGBAnimationTypeSlideDownReverse:
        case LGBAnimationTypeSlideUpReverse:
            [self lgb_PerformSlideAnimationType:type delay:delay duration:duration complete:complete];
            break;
        case LGBAnimationTypePop:
        case LGBAnimationTypePopAlphaIn:
        case LGBAnimationTypePopAlphaOut:
            [self lgb_PerformPopAlphaAnimationType:type delay:delay duration:duration complete:complete];
            break;
        case LGBAnimationTypeMorph:
            [self lgb_PerformMorphAnimationType:type delay:delay duration:duration complete:complete];
            break;
        case LGBAnimationTypeFlash:
            [self lgb_PerformFlashAnimationType:type delay:delay duration:duration complete:complete];
            break;
        case LGBAnimationTypeShake:
            [self lgb_PerformShakeAnimationType:type delay:delay duration:duration complete:complete];
            break;
        case LGBAnimationTypeZoomIn:
        case LGBAnimationTypeZoomOut:
            [self lgb_PerformZoomAnimationType:type delay:delay duration:duration complete:complete];
            break;
        case LGBAnimationTypePopDown:
        case LGBAnimationTypePopUp:
        case LGBAnimationTypePopAlphaUp:
            [self lgb_PerformPopAnimationType:type delay:delay duration:duration complete:complete];
            break;

        default:
            break;
    }
}

-(void)lgb_RemoveAnimation
{
    objc_setAssociatedObject(self, &kType, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)lgb_StartAnimationComplete:(void(^)(void))complete
{
    id animationType = objc_getAssociatedObject(self, &kType);
    if (animationType == nil) {
        return;
    }

    LGBAnimationType type = [animationType integerValue];
    CGFloat delay = [objc_getAssociatedObject(self, &kDelay) floatValue];
    CGFloat duration = [objc_getAssociatedObject(self, &kDuration) floatValue];

    [self lgb_PerformAnimationType:type delay:delay duration:duration complete:complete];
}

-(void)lgb_RemoveCanvasAnimation
{
    [[self subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj lgb_RemoveCanvasAnimation];
    }];
}

-(void)lgb_StartCanvasAnimation
{
    [[self subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj lgb_StartAnimationComplete:nil];
    }];
}

-(void)lgb_AddAnimationType:(LGBAnimationType)type delay:(CGFloat)delay duration:(CGFloat)duration
{
    objc_setAssociatedObject(self, &kType, @(type), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kDelay, @(delay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kDuration, @(duration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end
