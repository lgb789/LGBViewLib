//
//  UILabel+LGBLabel.m
//  AnimationCategory
//
//  Created by lgb789 on 2017/2/23.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import "UILabel+LGBLabel.h"

@implementation UILabel (LGBLabel)

-(void)lgb_SetTextWithDefaultLineSpace:(NSString *)text
{
    CGFloat lineSpace = self.font.pointSize * 0.4;
    [self lgb_SetText:text lineSpace:lineSpace];
}

-(void)lgb_SetText:(NSString *)text lineSpace:(CGFloat)lineSpace
{
    if (lineSpace < 0.01 || !text) {
        self.text = text;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    [attrString addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, text.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attrString;
}

+ (UILabel*)lgb_LabelWithBackgroundColor:(UIColor*)backgroundColor
                               textColor:(UIColor*)textColor
                           textAlignment:(NSTextAlignment)alignment
                           numberOfLines:(NSInteger)numberOfLines
                                    font:(UIFont*)font
                          adjustFontSize:(BOOL)adjust
{
    UILabel* lb                  = [UILabel new];
    lb.backgroundColor           = backgroundColor;
    lb.textColor                 = textColor;
    lb.textAlignment             = alignment;
    lb.numberOfLines             = numberOfLines;
    lb.font                      = font;
    lb.adjustsFontSizeToFitWidth = adjust;
    
    return lb;
}

- (void)lgb_setTextAttributes:(NSDictionary *)numberTextAttributes
{
    UIFont *font = [numberTextAttributes objectForKey:NSFontAttributeName];
    if (font) {
        self.font = font;
    }
    
    UIColor *textColor = [numberTextAttributes objectForKey:NSForegroundColorAttributeName];
    if (textColor) {
        self.textColor = textColor;
    }
   
    UIColor *backgroundColor = [numberTextAttributes objectForKey:NSBackgroundColorAttributeName];
    if (backgroundColor) {
        self.backgroundColor = backgroundColor;
    }
}

@end
