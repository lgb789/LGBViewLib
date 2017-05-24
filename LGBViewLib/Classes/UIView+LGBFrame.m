//
//  UIView+LGBFrame.m
//  rccsec
//
//  Created by lgb on 2017/4/19.
//  Copyright © 2017年 com.digiengine. All rights reserved.
//

#import "UIView+LGBFrame.h"

@implementation UIView (LGBFrame)
-(CGFloat)height
{
    return CGRectGetHeight(self.bounds);
}

-(CGFloat)width
{
    return CGRectGetWidth(self.bounds);
}

-(void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(CGFloat)x
{
    return CGRectGetMinX(self.frame);
}

-(CGFloat)y
{
    return CGRectGetMinY(self.frame);
}

-(void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
@end
