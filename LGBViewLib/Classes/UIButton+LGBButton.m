//
//  UIButton+LGBButton.m
//  AnimationCategory
//
//  Created by lgb789 on 2017/3/6.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import "UIButton+LGBButton.h"

@implementation UIButton (LGBButton)
#pragma mark - *********************** 创建对象 ***********************

+(UIButton *)lgb_ButtonTitle:(NSString *)title
                   titleFont:(UIFont *)titleFont
            titleNormalColor:(UIColor *)titleNormalColor
             titleStateColor:(UIColor *)titleStateColor
                    forState:(UIControlState)state
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleNormalColor forState:UIControlStateNormal];
    [button setTitleColor:titleStateColor forState:state];
    button.titleLabel.font = titleFont;
    
    return button;
}

+(UIButton *)lgb_ButtonImage:(UIImage *)image stateImage:(UIImage *)stateImage forState:(UIControlState)state
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setImage:image forState:UIControlStateNormal];
    [bt setImage:stateImage forState:state];
    
    return bt;
}

+(UIButton *)lgb_ButtonTitle:(NSString *)title
                   titleFont:(UIFont *)titleFont
                  titleColor:(UIColor *)titleColor
                  stateTitle:(NSString *)stateTitle
                    forState:(UIControlState)state
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:stateTitle forState:state];
    button.titleLabel.font = titleFont;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    return button;
}

#pragma mark - *********************** 对象方法 ***********************

-(void)lgb_SetBackgroundImage:(UIImage *)image stateImage:(UIImage *)stateImage forState:(UIControlState)state
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:stateImage forState:state];
}

@end
