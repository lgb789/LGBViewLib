//
//  UIAlertView+alertBlock.h
//  Pods
//
//  Created by mac_256 on 2017/7/17.
//
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewCompleteBlock)(UIAlertView * __nonnull alertView, NSInteger buttonIndex);

@interface UIAlertView (alertBlock)

+(instancetype _Nonnull )showWithTitle:(NSString *_Nullable)title
                               message:(NSString *_Nullable)message
                                 style:(UIAlertViewStyle)style
                     cancelButtonTitle:(NSString *_Nullable)cancelButtonTitle
                     otherButtonTitles:(NSArray *_Nullable)otherButtonTitles
                              tapBlock:(UIAlertViewCompleteBlock _Nullable )tapBlock;

+(instancetype _Nonnull )showWithTitle:(NSString *_Nullable
                                        )title
                               message:(NSString *_Nullable)message
                     cancelButtonTitle:(NSString *_Nullable)cancelButtonTitle
                     otherButtonTitles:(NSArray *_Nullable)otherButtonTitles
                              tapBlock:(UIAlertViewCompleteBlock _Nullable )tapBlock;


@end
