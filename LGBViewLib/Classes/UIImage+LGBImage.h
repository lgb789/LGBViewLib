//
//  UIImage+LGBImage.h
//  AnimationCategory
//
//  Created by lgb789 on 2017/3/6.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LGBImage)

/**
 根据颜色和圆角创建Image对象

 @param color 颜色
 @param cornerRadius 圆角半径
 @return Image对象
 */
+(UIImage *)lgb_ImageWithColor:(UIColor *)color
                  cornerRadius:(CGFloat)cornerRadius;

/**
 根据颜色创建Image对象

 @param color 颜色
 @return Image对象
 */
+(UIImage *)lgb_ImageWithColor:(UIColor *)color;

/**
 根据颜色大小创建圆形图片

 @param color 颜色
 @param size 大小
 @return Image对象
 */
+(UIImage *)lgb_CircleImageWithColor:(UIColor *)color
                                size:(CGSize)size;

/**
 根据模糊值创建模糊图片

 @param image 原图
 @param blurValue 模糊值
 @return 模糊图片
 */
+(UIImage *)lgb_BlurFromImage:(UIImage *)image blurValue:(CGFloat)blurValue;

/**
 创建视图的快照

 @param view 视图
 @return 快照
 */
+(UIImage *)lgb_ImageFromView:(UIView *)view;

/**
 根据layer生成图片

 @param layer layer
 @return UIImage
 */
+(UIImage *)lgb_imageFromLayer:(CALayer *)layer;

#pragma mark - *********************** 对象方法 ***********************

/**
 设置图片圆角

 @param radius 圆角半径
 @return 图片
 */
-(UIImage *)lgb_ImageWithCornerRadius:(CGFloat)radius;

-(UIImage*)lgb_imageRotatedByDegrees:(CGFloat)degrees;

@end
