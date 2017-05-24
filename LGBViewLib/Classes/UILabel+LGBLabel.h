//
//  UILabel+LGBLabel.h
//  AnimationCategory
//
//  Created by lgb789 on 2017/2/23.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LGBLabel)

/**
 设置文本以及行距
 
 默认行距是字体大小的0.4倍

 @param text 文本
 */
-(void)lgb_SetTextWithDefaultLineSpace:(NSString *)text;

/**
 设置文本以及行距

 @param text 文本
 @param lineSpace 行距
 */
-(void)lgb_SetText:(NSString *)text lineSpace:(CGFloat)lineSpace;

/**
 创建UILable

 @param backgroundColor 背景色
 @param textColor 字体颜色
 @param alignment 对齐方式
 @param numberOfLines 行数，0表示多行
 @param font 字体
 @param adjust 是否自动调节字体大小
 @return UILabel
 */
+ (UILabel*)lgb_LabelWithBackgroundColor:(UIColor*)backgroundColor
                               textColor:(UIColor*)textColor
                           textAlignment:(NSTextAlignment)alignment
                           numberOfLines:(NSInteger)numberOfLines
                                    font:(UIFont*)font
                          adjustFontSize:(BOOL)adjust;


- (void)lgb_setTextAttributes:(NSDictionary *)numberTextAttributes UI_APPEARANCE_SELECTOR;

@end
