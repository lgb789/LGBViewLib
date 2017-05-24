//
//  UITextView+LGBText.h
//  AnimationCategory
//
//  Created by lgb789 on 2017/3/2.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (LGBTextView)

/**
 设置默认行间距为字体大小的0.8倍

 @param text 要显示的文本
 */
-(void)lgb_SetTextWithDefaultLineSpace:(NSString *)text;

/**
 设置行间距

 @param text 要显示的文本
 @param lineSpace 行间距
 */
-(void)lgb_SetText:(NSString *)text lineSpace:(CGFloat)lineSpace;

/**
 创建UITextView对象

 @param backgroundColor 背景色
 @param textColor 文本颜色
 @param font 字体
 @param alignment 对齐方式
 @param editable 是否可编辑
 @param selectable 是否可选
 @return 返回UITextView对象
 */
+(UITextView *)lgb_TextViewWithBackgroundColor:(UIColor *)backgroundColor
                                     textColor:(UIColor *)textColor
                                          font:(UIFont *)font
                                 textAlignment:(NSTextAlignment)alignment
                                      editable:(BOOL)editable
                                    selectable:(BOOL)selectable
                                  scrollEnable:(BOOL)scrollEnable;


- (void)lgb_setTextAttributes:(NSDictionary *)numberTextAttributes UI_APPEARANCE_SELECTOR;

@end
