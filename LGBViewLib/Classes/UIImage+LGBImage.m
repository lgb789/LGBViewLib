//
//  UIImage+LGBImage.m
//  AnimationCategory
//
//  Created by lgb789 on 2017/3/6.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import "UIImage+LGBImage.h"

@implementation UIImage (LGBImage)

//static CGFloat minRadius(CGFloat radius)
//{
//    return radius * 2 + 1;
//}

#pragma mark - *********************** 创建UIImage对象 ***********************
//圆角图片
+(UIImage *)lgb_ImageWithColor:(UIColor *)color
                  cornerRadius:(CGFloat)cornerRadius
{
    CGSize minSize = CGSizeMake(cornerRadius * 2 + 1, cornerRadius * 2 + 1);
//    CGSize minSize = size;
    UIGraphicsBeginImageContextWithOptions(minSize, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, minSize.width, minSize.height) cornerRadius:cornerRadius];
    [color setFill];
    [color setStroke];
    
    [path addClip];
    [path fill];
    [path stroke];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
    
    return img;
}

//颜色图片
+(UIImage *)lgb_ImageWithColor:(UIColor *)color
{
    return [self lgb_ImageWithColor:color cornerRadius:0];
}

//圆形图片
+(UIImage *)lgb_CircleImageWithColor:(UIColor *)color
                                size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    [color setFill];
    [color setStroke];
    
    [path addClip];
    [path fill];
    [path stroke];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

//模糊图片
+(UIImage *)lgb_BlurFromImage:(UIImage *)image blurValue:(CGFloat)blurValue
{
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    
    //因为在模糊的时候，边缘会变成半透明的状态，所以理想状况是可以对原图像进行适当放大，选择使用CIAffineClamp在模糊之前对图像进行处理
    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    CGAffineTransform xform = CGAffineTransformMakeScale(1.0, 1.0);
    [affineClampFilter setValue:inputImage forKey:kCIInputImageKey];
    [affineClampFilter setValue:[NSValue valueWithBytes:&xform
                                               objCType:@encode(CGAffineTransform)]
                         forKey:@"inputTransform"];
    
    CIImage *extendedImage = [affineClampFilter valueForKey:kCIOutputImageKey];
    
    //模糊滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:extendedImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:blurValue] forKey:@"inputRadius"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    //ARC不会释放CGImageRef，需要手动释放
    CGImageRelease(cgImage);
    
    return returnImage;
}

//view图片
+(UIImage *)lgb_ImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    }else{
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

//layer图片
+(UIImage *)lgb_imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContext([layer frame].size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


#pragma mark - *********************** 对象方法 ***********************
//设置图片圆角
-(UIImage *)lgb_ImageWithCornerRadius:(CGFloat)radius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [path addClip];
    [self drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

-(UIImage*)lgb_imageRotatedByDegrees:(CGFloat)degrees
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
