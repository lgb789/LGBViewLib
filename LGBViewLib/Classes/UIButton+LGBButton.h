//
//  UIButton+LGBButton.h
//  AnimationCategory
//
//  Created by lgb789 on 2017/3/6.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LGBButton)

/**
 创建Button对象，当状态改变时，标题颜色改变

 @param title 标题
 @param titleFont 标题字体
 @param titleNormalColor 标题常规色
 @param titleStateColor 标题状态色
 @param state 状态
 @return Button对象
 */
+(UIButton *)lgb_ButtonTitle:(NSString *)title
                   titleFont:(UIFont *)titleFont
            titleNormalColor:(UIColor *)titleNormalColor
             titleStateColor:(UIColor *)titleStateColor
                    forState:(UIControlState)state;

/**
 创建Button对象，当状态改变时，图片改变

 @param image 按钮图片
 @param stateImage 按钮状态图片
 @param state 状态
 @return Button对象
 */
+(UIButton *)lgb_ButtonImage:(UIImage *)image stateImage:(UIImage *)stateImage forState:(UIControlState)state;

/**
 创建Button对象，当状态改变时，标题改变

 @param title 标题
 @param titleFont 字体
 @param titleColor 标题颜色
 @param stateTitle 状态标题
 @param state 状态
 @return Button对象
 */
+(UIButton *)lgb_ButtonTitle:(NSString *)title
                   titleFont:(UIFont *)titleFont
                  titleColor:(UIColor *)titleColor
                  stateTitle:(NSString *)stateTitle
                    forState:(UIControlState)state;

/**
 设置按钮背景图片，当状态改变时，背景图片改变

 @param image 按钮常规背景图
 @param stateImage 按钮状态背景图
 @param state 状态
 */
-(void)lgb_SetBackgroundImage:(UIImage *)image stateImage:(UIImage *)stateImage forState:(UIControlState)state;

@end
