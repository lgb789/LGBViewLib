//
//  ZADisplayController.h
//  Common
//
//  Created by lgb789 on 2017/3/13.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZADisplayMaskTypeDark,
    ZADisplayMaskTypeLight,
} ZADisplayMaskType;

typedef enum : NSUInteger {
    ZADisplayViewPositionCenter,
    ZADisplayViewPositionTop,
    ZADisplayViewPositionBottom,
    ZADisplayViewPositionLeft,
    ZADisplayViewPositionRight,
} ZADisplayViewPosition;

typedef void(^ZADisplayTapBackground)(void);

@interface ZADisplayController : UIViewController
@property (nonatomic, assign) ZADisplayMaskType maskType;
@property (nonatomic, assign) BOOL blur;
@property (nonatomic, assign) BOOL shrink;
@property (nonatomic, copy) ZADisplayTapBackground tapBackground;

-(void)dismissFromParentAnimated:(BOOL)animated duration:(CGFloat)duration;

-(void)displayView:(UIView *)view inViewController:(UIViewController *)controller position:(ZADisplayViewPosition)position;

-(void)displayView:(UIView *)view inViewController:(UIViewController *)controller;

@end
