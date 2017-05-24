//
//  UITextView+LGBText.m
//  AnimationCategory
//
//  Created by lgb789 on 2017/3/2.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import "UITextView+LGBTextView.h"

@implementation UITextView (LGBTextView)

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
    [attrString addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, [text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setAlignment:self.textAlignment];
    
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attrString;
}


+(UITextView *)lgb_TextViewWithBackgroundColor:(UIColor *)backgroundColor
                                     textColor:(UIColor *)textColor
                                          font:(UIFont *)font
                                 textAlignment:(NSTextAlignment)alignment
                                      editable:(BOOL)editable
                                    selectable:(BOOL)selectable
                                  scrollEnable:(BOOL)scrollEnable
{
    UITextView *txtView = [UITextView new];
    txtView.backgroundColor = backgroundColor;
    txtView.textColor = textColor;
    txtView.font = font;
    txtView.textAlignment = alignment;
    txtView.editable = editable;
    txtView.selectable = selectable;
    txtView.scrollEnabled = scrollEnable;
    
    return txtView;
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
