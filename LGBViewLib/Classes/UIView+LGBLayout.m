//
//  UIView+LGBLayout.m
//  AnimationCategory
//
//  Created by lgb789 on 2017/2/24.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import "UIView+LGBLayout.h"
#import <objc/runtime.h>
#import "LGBDefine.h"

#define GetterSpace(name, dir)              ZA_getterCon(name, [self spaceToViewWithDirection:dir])

#define GetterValue(name, key)              ZA_getterCon(name, [self valueIsWithType:key])

#define GetterAlign(name, dir)              ZA_getterCon(name, [self alignToViewWithType:dir])

#define GetterRadio(name, key)              ZA_getterCon(name, [self sizeRatioToViewWithType:key])

#define GetterSpaceLeftValue(name, value)   ZA_getterCon(name, [self spaceToViewLeftValue:value])

#define GetterSpaceTopValue(name, value)    ZA_getterCon(name, [self spaceToViewTopValue:value])

#define GetterSpaceRightValue(name, value)  ZA_getterCon(name, [self spaceToViewRightValue:value])

#define GetterSpaceDownValue(name, value)   ZA_getterCon(name, [self spaceToViewDownValue:value])

#define GetterAlignLeftValue(name, value)   ZA_getterCon(name, [self alignToViewLeftValue:value])

#define GetterAlignTopValue(name, value)    ZA_getterCon(name, [self alignToViewTopValue:value])

#define GetterAlignRightValue(name, value)  ZA_getterCon(name, [self alignToViewRightValue:value])

#define GetterAlignDownValue(name, value)   ZA_getterCon(name, [self alignToViewDownValue:value])

#define GetterWidth(name, value)            ZA_getterCon(name, [self widthValue:value])

#define GetterHeight(name, value)           ZA_getterCon(name, [self heightValue:value])

typedef LGBLayoutManager* (^SubviewsEqualToView)(UIView *view, CGFloat space, CGFloat count);

static void *kLayoutManager;

/*********************** LGBLayoutItem ***********************/
@interface LGBLayoutItem : NSObject
@property (nonatomic, weak) UIView *view;
@property (nonatomic, assign) CGFloat value;
@end

@implementation LGBLayoutItem

@end
/*********************** LGBLayoutItemRatio ***********************/
@interface LGBLayoutItemRatio : LGBLayoutItem
@property (nonatomic, assign) CGFloat count;
@end

@implementation LGBLayoutItemRatio



@end
/*********************** LGBLayoutItemArray ***********************/
@interface LGBLayoutItemArray : NSObject
@property (nonatomic, strong) NSArray *views;
@property (nonatomic, assign) CGFloat value;
@end

@implementation LGBLayoutItemArray



@end
/*********************** LGBLayoutManager ***********************/
@interface LGBLayoutManager ()

/*********************** 边距 ***********************/
@property (nonatomic, strong) LGBLayoutItem *left;
@property (nonatomic, strong) LGBLayoutItem *top;
@property (nonatomic, strong) LGBLayoutItem *right;
@property (nonatomic, strong) LGBLayoutItem *down;

/*********************** 绝对值 ***********************/
@property (nonatomic, strong) LGBLayoutItem *x;
@property (nonatomic, strong) LGBLayoutItem *y;
@property (nonatomic, strong) LGBLayoutItem *width;
@property (nonatomic, strong) LGBLayoutItem *height;

/*********************** 中心点对齐 ***********************/
@property (nonatomic, strong) LGBLayoutItem *centerX;
@property (nonatomic, strong) LGBLayoutItem *centerY;
@property (nonatomic, strong) LGBLayoutItem *center;

/*********************** 大小比例 ***********************/
@property (nonatomic, strong) LGBLayoutItem *ratioWidth;
@property (nonatomic, strong) LGBLayoutItem *ratioHeight;
@property (nonatomic, strong) LGBLayoutItem *ratio;
@property (nonatomic, strong) LGBLayoutItem *widthRatioToHeight;
@property (nonatomic, strong) LGBLayoutItem *heightRatioToWidth;

/*********************** 边对齐 ***********************/
@property (nonatomic, strong) LGBLayoutItem *alignLeft;
@property (nonatomic, strong) LGBLayoutItem *alignTop;
@property (nonatomic, strong) LGBLayoutItem *alignRight;
@property (nonatomic, strong) LGBLayoutItem *alignDown;

/*********************** 子视图的宽或高相等 ***********************/
@property (nonatomic, copy) SubviewsEqualToView subviewsEqualToViewWidth;
@property (nonatomic, copy) SubviewsEqualToView subviewsEqualToViewHeight;

@property (nonatomic, strong) LGBLayoutItemRatio *subviewsWidth;
@property (nonatomic, strong) LGBLayoutItemRatio *subviewsHeight;


/*********************** 设置content size ***********************/
@property (nonatomic, strong) LGBLayoutItem *contentBottom;
@property (nonatomic, strong) LGBLayoutItem *contentRight;

/*********************** 数组对齐 ***********************/
@property (nonatomic, strong) LGBLayoutItemArray *arrayBottom;
@property (nonatomic, strong) LGBLayoutItemArray *arrayRight;
@end

@implementation LGBLayoutManager

//Space 间距
-(SpaceToView)spaceToViewWithDirection:(NSString *)direction
{
    __weak typeof(self) weakSelf = self;
    return ^(UIView *view, CGFloat value){
        LGBLayoutItem *item = [LGBLayoutItem new];
        item.view = view;
        item.value = value;
        [weakSelf setValue:item forKey:direction];
        return weakSelf;
    };
}

-(SpaceToViewValue)spaceToViewLeftValue:(CGFloat)value {return [self spaceToViewWithKey:@"left" value:value];}

-(SpaceToViewValue)spaceToViewTopValue:(CGFloat)value {return [self spaceToViewWithKey:@"top" value:value];}

-(SpaceToViewValue)spaceToViewRightValue:(CGFloat)value {return [self spaceToViewWithKey:@"right" value:value];}

-(SpaceToViewValue)spaceToViewDownValue:(CGFloat)value {return [self spaceToViewWithKey:@"down" value:value];}

-(SpaceToViewValue)spaceToViewWithKey:(NSString *)key value:(CGFloat)value
{
    __weak typeof(self) weakSelf = self;
    return ^(UIView *view){
        if ([key isEqualToString:@"left"]) {
            weakSelf.spaceToViewLeft(view, value);
        }else if ([key isEqualToString:@"top"]){
            weakSelf.spaceToViewTop(view, value);
        }else if ([key isEqualToString:@"right"]){
            weakSelf.spaceToViewRight(view, value);
        }else if ([key isEqualToString:@"down"]){
            weakSelf.spaceToViewDown(view, value);
        }
        
        return weakSelf;
    };
}

//Frame 绝对值
-(ValueIs)valueIsWithType:(NSString *)type
{
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value){
        LGBLayoutItem *item = [LGBLayoutItem new];
        item.value = value;
        [weakSelf setValue:item forKey:type];
        return weakSelf;
    };
}

-(ValueIsABS)widthValue:(CGFloat)value
{
    __weak typeof(self) weakSelf = self;

    return ^(void){
        weakSelf.isWidth(value);
        return weakSelf;
    };
}

-(ValueIsABS)heightValue:(CGFloat)value
{
    __weak typeof(self) weakSelf = self;
    
    return ^(void){
        weakSelf.isHeight(value);
        return weakSelf;
    };
}

//Center 中心点
-(CenterEqualToView)centerEqualToViewWithType:(NSString *)type
{
    __weak typeof(self) weakSelf = self;
    return ^(UIView *view, CGFloat value){
        LGBLayoutItem *item = [LGBLayoutItem new];
        item.view = view;
        item.value = value;
        [weakSelf setValue:item forKey:type];
        return weakSelf;
    };
}

-(CenterCompleteEqualToView)centerCompleteEqualToView
{
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        LGBLayoutItem *item = [LGBLayoutItem new];
        item.view = view;
        [weakSelf setValue:item forKey:@"center"];
        return weakSelf;
    };
}

//Size 大小
-(SizeRatioToView)sizeRatioToViewWithType:(NSString *)type
{
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view, CGFloat value){
        LGBLayoutItem *item = [LGBLayoutItem new];
        item.view = view;
        item.value = value;
        [weakSelf setValue:item forKey:type];
        return weakSelf;
    };
}

-(WidthHeightEqual)widthHeightWithType:(NSString *)type
{
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value){
        LGBLayoutItem *item = [LGBLayoutItem new];
        item.value = value;
        [weakSelf setValue:item forKey:type];
        return weakSelf;
    };
}

//Align 对齐
-(AlignToView)alignToViewWithType:(NSString *)type
{
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view, CGFloat value){
        LGBLayoutItem *item = [LGBLayoutItem new];
        item.view = view;
        item.value = value;
        [weakSelf setValue:item forKey:type];
        return weakSelf;
    };
}

-(AlignToViewValue)alignToViewLeftValue:(CGFloat)value {return [self alignToViewWithKey:@"left" value:value];}

-(AlignToViewValue)alignToViewTopValue:(CGFloat)value {return [self alignToViewWithKey:@"top" value:value];}

-(AlignToViewValue)alignToViewRightValue:(CGFloat)value {return [self alignToViewWithKey:@"right" value:value];}

-(AlignToViewValue)alignToViewDownValue:(CGFloat)value {return [self alignToViewWithKey:@"down" value:value];}

-(AlignToViewValue)alignToViewWithKey:(NSString *)key value:(CGFloat)value
{
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        if ([key isEqualToString:@"left"]) {
            weakSelf.alignToViewLeft(view, value);
        }else if ([key isEqualToString:@"top"]){
            weakSelf.alignToViewTop(view, value);
        }else if ([key isEqualToString:@"right"]){
            weakSelf.alignToViewRight(view, value);
        }else if ([key isEqualToString:@"down"]){
            weakSelf.alignToViewDown(view, value);
        }
        
        return weakSelf;
    };
}

//子视图的宽或高相等
-(SubviewsEqualToView)subviewsEqualToViewWithType:(NSString *)type
{
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view, CGFloat space, CGFloat count){
        LGBLayoutItemRatio *item = [LGBLayoutItemRatio new];
        item.view = view;
        item.value = space;
        item.count = count;
        [weakSelf setValue:item forKey:type];
        return weakSelf;
    };
}

//设置scroll view content size
-(ScrollContentAlignToView)contentAlignToViewWithType:(NSString *)type
{
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view, CGFloat value){
        LGBLayoutItem *item = [LGBLayoutItem new];
        item.view = view;
        item.value = value;
        [weakSelf setValue:item forKey:type];
        return weakSelf;
    };
}

//设置对齐数组中的view
-(AlignToViewArray)alignToViewArrayWithType:(NSString *)type
{
    __weak typeof(self) weakSelf = self;
    
    return ^(NSArray *views, CGFloat value){
        LGBLayoutItemArray *item = [LGBLayoutItemArray new];
        item.views = views;
        item.value = value;
        [weakSelf setValue:item forKey:type];
        return weakSelf;
    };
}

//getter方法
-(SpaceToView)spaceToViewDown {GetterSpace(_spaceToViewDown, @"down");}

-(SpaceToView)spaceToViewRight {GetterSpace(_spaceToViewRight, @"right");}

-(SpaceToView)spaceToViewTop {GetterSpace(_spaceToViewTop, @"top");}

-(SpaceToView)spaceToViewLeft {GetterSpace(_spaceToViewLeft, @"left");}

-(ValueIs)isX {GetterValue(_isX, @"x");}

-(ValueIs)isY {GetterValue(_isY, @"y");}

-(ValueIs)isWidth {GetterValue(_isWidth, @"width");}

-(ValueIs)isHeight {GetterValue(_isHeight, @"height");}

-(CenterEqualToView)centerEqualToViewX {ZA_getterCon(_centerEqualToViewX, [self centerEqualToViewWithType:@"centerX"]);}

-(CenterEqualToView)centerEqualToViewY {ZA_getterCon(_centerEqualToViewY, [self centerEqualToViewWithType:@"centerY"]);}

-(CenterCompleteEqualToView)centerEqualToView {ZA_getterCon(_centerEqualToView, [self centerCompleteEqualToView]);}

-(SizeRatioToView)sizeRatioToViewWidth {GetterRadio(_sizeRatioToViewWidth, @"ratioWidth");}

-(SizeRatioToView)sizeRatioToViewHeight {GetterRadio(_sizeRatioToViewHeight, @"ratioHeight");}

-(WidthHeightEqual)widthEqualToHeight
{
    if (_widthEqualToHeight == nil) {
        _widthEqualToHeight = [self widthHeightWithType:@"widthRatioToHeight"];
    }
    return _widthEqualToHeight;
}

-(WidthHeightEqual)heightEqualToWidth
{
    if (_heightEqualToWidth == nil) {
        _heightEqualToWidth = [self widthHeightWithType:@"heightRatioToWidth"];
    }
    return _heightEqualToWidth;
}

-(SizeRatioToView)sizeRatioToView {GetterRadio(_sizeRatioToView, @"ratio");}

-(AlignToView)alignToViewLeft {GetterAlign(_alignToViewLeft, @"alignLeft");}

-(AlignToView)alignToViewTop {GetterAlign(_alignToViewTop, @"alignTop");}

-(AlignToView)alignToViewRight {GetterAlign(_alignToViewRight, @"alignRight");}

-(AlignToView)alignToViewDown {GetterAlign(_alignToViewDown, @"alignDown");}

-(SubviewsEqualToView)subviewsEqualToViewWidth {ZA_getterCon(_subviewsEqualToViewWidth, [self subviewsEqualToViewWithType:@"subviewsWidth"]);}

-(SubviewsEqualToView)subviewsEqualToViewHeight {ZA_getterCon(_subviewsEqualToViewHeight, [self subviewsEqualToViewWithType:@"subviewsHeight"]);}

-(ScrollContentAlignToView)contentAlignToViewBottom {ZA_getterCon(_contentAlignToViewBottom, [self contentAlignToViewWithType:@"contentBottom"]);}

-(ScrollContentAlignToView)contentAlignToViewRight {ZA_getterCon(_contentAlignToViewRight, [self contentAlignToViewWithType:@"contentRight"]);}

-(AlignToViewArray)alignToViewArrayBottom {ZA_getterCon(_alignToViewArrayBottom, [self alignToViewArrayWithType:@"arrayBottom"]);}

-(AlignToViewArray)alignToViewArrayRight {ZA_getterCon(_alignToViewArrayRight, [self alignToViewArrayWithType:@"arrayRight"]);}

-(SpaceToViewValue)spaceToViewLeft_0p {GetterSpaceLeftValue(_spaceToViewLeft_0p, 0);}

-(SpaceToViewValue)spaceToViewLeft_5p {GetterSpaceLeftValue(_spaceToViewLeft_5p, 5);}

-(SpaceToViewValue)spaceToViewLeft_8p {GetterSpaceLeftValue(_spaceToViewLeft_8p, 8);}

-(SpaceToViewValue)spaceToViewLeft_10p {GetterSpaceLeftValue(_spaceToViewLeft_10p, 10);}

-(SpaceToViewValue)spaceToViewLeft_15p {GetterSpaceLeftValue(_spaceToViewLeft_15p, 15);}

-(SpaceToViewValue)spaceToViewTop_0p {GetterSpaceTopValue(_spaceToViewTop_0p, 0);}

-(SpaceToViewValue)spaceToViewTop_5p {GetterSpaceTopValue(_spaceToViewTop_5p, 5);}

-(SpaceToViewValue)spaceToViewTop_8p {GetterSpaceTopValue(_spaceToViewTop_8p, 8);}

-(SpaceToViewValue)spaceToViewTop_10p {GetterSpaceTopValue(_spaceToViewTop_10p, 10);}

-(SpaceToViewValue)spaceToViewTop_15p {GetterSpaceTopValue(_spaceToViewTop_15p, 15);}

-(SpaceToViewValue)spaceToViewRight_0p {GetterSpaceRightValue(_spaceToViewRight_0p, 0);}

-(SpaceToViewValue)spaceToViewRight_5p {GetterSpaceRightValue(_spaceToViewRight_5p, 5);}

-(SpaceToViewValue)spaceToViewRight_8p {GetterSpaceRightValue(_spaceToViewRight_8p, 8);}

-(SpaceToViewValue)spaceToViewRight_10p {GetterSpaceRightValue(_spaceToViewRight_10p, 10);}

-(SpaceToViewValue)spaceToViewRight_15p {GetterSpaceRightValue(_spaceToViewRight_15p, 15);}

-(SpaceToViewValue)spaceToViewDown_0p {GetterSpaceDownValue(_spaceToViewDown_0p, 0);}

-(SpaceToViewValue)spaceToViewDown_5p {GetterSpaceDownValue(_spaceToViewDown_5p, 5);}

-(SpaceToViewValue)spaceToViewDown_8p {GetterSpaceDownValue(_spaceToViewDown_8p, 8);}

-(SpaceToViewValue)spaceToViewDown_10p {GetterSpaceDownValue(_spaceToViewDown_10p, 10);}

-(SpaceToViewValue)spaceToViewDown_15p {GetterSpaceDownValue(_spaceToViewDown_15p, 15);}

-(AlignToViewValue)alignToViewLeft_0p {GetterAlignLeftValue(_alignToViewLeft_0p,0);}

-(AlignToViewValue)alignToViewLeft_5p {GetterAlignLeftValue(_alignToViewLeft_5p, -5);}

-(AlignToViewValue)alignToViewLeft_8p {GetterAlignLeftValue(_alignToViewLeft_8p, -8);}

-(AlignToViewValue)alignToViewLeft_10p {GetterAlignLeftValue(_alignToViewLeft_10p, -10);}

-(AlignToViewValue)alignToViewLeft_15p {GetterAlignLeftValue(_alignToViewLeft_15p, -15);}

-(AlignToViewValue)alignToViewTop_0p {GetterAlignTopValue(_alignToViewTop_0p, 0);}

-(AlignToViewValue)alignToViewTop_5p {GetterAlignTopValue(_alignToViewTop_5p, -5);}

-(AlignToViewValue)alignToViewTop_8p {GetterAlignTopValue(_alignToViewTop_8p, -8);}

-(AlignToViewValue)alignToViewTop_10p {GetterAlignTopValue(_alignToViewTop_10p, -10);}

-(AlignToViewValue)alignToViewTop_15p {GetterAlignTopValue(_alignToViewTop_15p, -15);}

-(AlignToViewValue)alignToViewRight_0p {GetterAlignRightValue(_alignToViewRight_0p, 0);}

-(AlignToViewValue)alignToViewRight_5p {GetterAlignRightValue(_alignToViewRight_5p, -5);}

-(AlignToViewValue)alignToViewRight_8p {GetterAlignRightValue(_alignToViewRight_8p, -8);}

-(AlignToViewValue)alignToViewRight_10p {GetterAlignRightValue(_alignToViewRight_10p, -10);}

-(AlignToViewValue)alignToViewRight_15p {GetterAlignRightValue(_alignToViewRight_15p, -15);}

-(AlignToViewValue)alignToViewDown_0p {GetterAlignDownValue(_alignToViewDown_0p, 0);}

-(AlignToViewValue)alignToViewDown_5p {GetterAlignDownValue(_alignToViewDown_5p, -5);}

-(AlignToViewValue)alignToViewDown_8p {GetterAlignDownValue(_alignToViewDown_8p, -8);}

-(AlignToViewValue)alignToViewDown_10p {GetterAlignDownValue(_alignToViewDown_10p, -10);}

-(AlignToViewValue)alignToViewDown_15p {GetterAlignDownValue(_alignToViewDown_15p, -15);}

-(ValueIsABS)isWidth_29p {GetterWidth(_isWidth_29p, 29);}

-(ValueIsABS)isWidth_30p {GetterWidth(_isWidth_30p, 30);}

-(ValueIsABS)isWidth_94p {GetterWidth(_isWidth_94p, 94);}

-(ValueIsABS)isWidth_270p {GetterWidth(_isWidth_270p, 270);}

-(ValueIsABS)isWidth_51p {GetterWidth(_isWidth_51p, 51);}

-(ValueIsABS)isWidth_24p {GetterWidth(_isWidth_24p, 24);}

-(ValueIsABS)isHeight_29p {GetterHeight(_isHeight_29p, 29);}

-(ValueIsABS)isHeight_44p {GetterHeight(_isHeight_44p, 44);}

-(ValueIsABS)isHeight_31p {GetterHeight(_isHeight_31p, 31);}

-(ValueIsABS)isHeight_2p {GetterHeight(_isHeight_2p, 2);}

-(ValueIsABS)isHeight_30p {GetterHeight(_isHeight_30p, 30);}

-(ValueIsABS)isHeight_217p {GetterHeight(_isHeight_217p, 217);}

-(ValueIsABS)isHeight_49p {GetterHeight(_isHeight_49p, 49);}

-(ValueIsABS)isHeight_20p {GetterHeight(_isHeight_20p, 20);}

-(ValueIsABS)isHeight_24p {GetterHeight(_isHeight_24p, 24);}

-(ValueIsABS)isHeight_57p {GetterHeight(_isHeight_57p, 57);}

-(ValueIsABS)isHeight_36p {GetterHeight(_isHeight_36p, 36);}

@end








/*********************** UIView (LGBLayout) ***********************/
@implementation UIView (LGBLayout)

//替换方法
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oldMethod = class_getInstanceMethod(self, NSSelectorFromString(@"layoutSubviews"));
        Method newMethod = class_getInstanceMethod(self, NSSelectorFromString(@"lgb_LayoutSubviews"));
        method_exchangeImplementations(oldMethod, newMethod);
    });
}

//设置 x 坐标
-(void)lgb_SetX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

//设置 y 坐标
-(void)lgb_SetY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

//设置宽
-(void)lgb_SetWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

//设置高
-(void)lgb_SetHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

//获取 x 坐标
-(CGFloat)lgb_GetX
{
    LGBLayoutManager *manager = [self lgb_GetLayoutManager];
    return [self lgb_GetXWithManager:manager];
}

-(CGRect)lgb_GetRectRefView:(UIView *)refView x:(CGFloat)x width:(CGFloat)width
{
    CGRect rect = CGRectMake(x, 0, width, 0);
    CGRect refRect = [(refView.superview ? refView.superview : refView) convertRect:rect toView:self.superview];
    return refRect;
}

-(CGFloat)lgb_GetXWithManager:(LGBLayoutManager *)manager layoutItem:(LGBLayoutItem *)item
{
    UIView *refView = item.view;
    CGFloat originWidth = [self lgb_GetWidthWithManager:manager];
    CGRect refRect = [self lgb_GetRectRefView:refView x:[refView lgb_GetX] width:[refView lgb_GetWidth]];
    CGFloat result = CGRectGetMidX(refRect) - originWidth / 2 + item.value;
    
    return result;
}

-(CGFloat)lgb_GetXWithManager:(LGBLayoutManager *)manager
{
    CGFloat result = CGRectGetMinX(self.frame);
    if (manager.left) {
        UIView *refView = manager.left.view;

        if (refView == self.superview) {
            result = manager.left.value;
        }else{
            CGRect refRect = [self lgb_GetRectRefView:refView x:[refView lgb_GetX] width:[refView lgb_GetWidth]];
            result = CGRectGetMaxX(refRect) + manager.left.value;
        }
        
    }else if (manager.x){
        result = manager.x.value;
        
    }else if (manager.centerX){
        result = [self lgb_GetXWithManager:manager layoutItem:manager.centerX];
    }else if (manager.center){
        result = [self lgb_GetXWithManager:manager layoutItem:manager.center];
    }else if (manager.alignLeft){
        UIView *refView = manager.alignLeft.view;
        if (refView == self.superview) {
            result = manager.alignLeft.value;
        }else{
            CGRect refRect = [self lgb_GetRectRefView:refView x:[refView lgb_GetX] width:0];
            result = CGRectGetMinX(refRect) + manager.alignLeft.value;
        }
    }else if (manager.right){//通过右边距计算self的x坐标
        UIView *refView = manager.right.view;
        //需要调用此方法获得self的宽，此方法里面不包含manager.right条件，否则获取的宽不正确
        CGFloat originWidth = [self lgb_GetDirectWidthWithManager:manager];

        if (refView == self.superview) {
            result = [refView lgb_GetWidth] - originWidth - manager.right.value;
        }else{

            CGRect refRect = [self lgb_GetRectRefView:refView x:[refView lgb_GetX] width:0];
            result = CGRectGetMinX(refRect) - originWidth - manager.right.value;
        }
        
    }else if (manager.alignRight){
        UIView *refView = manager.alignRight.view;
        CGFloat width = [refView lgb_GetWidth];
        CGFloat originWidth = [self lgb_GetDirectWidthWithManager:manager];
        if (refView == self.superview) {
            result = width - originWidth - manager.alignRight.value;
        }else{
            CGRect refRect = [self lgb_GetRectRefView:refView x:[refView lgb_GetX] width:width];
            result = CGRectGetMaxX(refRect) - originWidth - manager.alignRight.value;
        }
        
    }
    
    return result;
}

//获取 y 坐标
-(CGFloat)lgb_GetY
{
    LGBLayoutManager *manager = [self lgb_GetLayoutManager];
    return [self lgb_GetYWithManager:manager];
}

-(CGRect)lgb_GetRectRefView:(UIView *)refView y:(CGFloat)y height:(CGFloat)height
{
    CGRect rect = CGRectMake(0, y, 0, height);
    CGRect refRect = [(refView.superview ? refView.superview : refView) convertRect:rect toView:self.superview];
    return refRect;
}

-(CGFloat)lgb_GetYWithManager:(LGBLayoutManager *)manager layoutItem:(LGBLayoutItem *)item
{
    UIView *refView = item.view;

    CGFloat originHeight = [self lgb_GetHeightWithManager:manager];
    CGRect refRect = [self lgb_GetRectRefView:refView y:[refView lgb_GetY] height:[refView lgb_GetHeight]];
    CGFloat result = CGRectGetMidY(refRect) - originHeight / 2 + item.value;
    
    return result;
}

-(CGFloat)lgb_GetYWithManager:(LGBLayoutManager *)manager
{
    CGFloat result = CGRectGetMinY(self.frame);
    if (manager.top) {
        UIView *refView = manager.top.view;

        if (refView == self.superview) {
            result = manager.top.value;
        }else{
            CGRect refRect = [self lgb_GetRectRefView:refView y:[refView lgb_GetY] height:[refView lgb_GetHeight]];
            result = CGRectGetMaxY(refRect) + manager.top.value;
        }
        
    }else if (manager.y){
        result = manager.y.value;
    }else if (manager.centerY){
        result = [self lgb_GetYWithManager:manager layoutItem:manager.centerY];
    }else if (manager.center){
        result = [self lgb_GetYWithManager:manager layoutItem:manager.center];
    }else if (manager.alignTop){
        UIView *refView = manager.alignTop.view;
        if (refView == self.superview) {
            result = manager.alignTop.value;
        }else{
            CGRect refRect = [self lgb_GetRectRefView:refView y:[refView lgb_GetY] height:0];
            result = CGRectGetMinY(refRect) + manager.alignTop.value;
        }
        
    }else if (manager.down){//通过下边距计算self的y坐标
        UIView *refView = manager.down.view;

        //调用此方法获取self的高度，此方法里面不包含manager.down条件，否则计算的高度不正确
        CGFloat originHeight = [self lgb_GetDirectHeightWithManager:manager];
        if (refView == self.superview) {

            result = [refView lgb_GetHeight] - manager.down.value - originHeight;
        }else{

            CGRect refRect = [self lgb_GetRectRefView:refView y:[refView lgb_GetY] height:0];
            result = CGRectGetMinY(refRect) - manager.down.value - originHeight;
        }
        
    }else if (manager.alignDown){
        UIView *refView = manager.alignDown.view;
        CGFloat height = [refView lgb_GetHeight];
        CGFloat originHeight = [self lgb_GetDirectHeightWithManager:manager];
        if (refView == self.superview) {
            result = height - originHeight - manager.alignDown.value;
        }else{
            CGRect refRect = [self lgb_GetRectRefView:refView y:[refView lgb_GetY] height:height];
            result = CGRectGetMaxY(refRect) - originHeight - manager.alignDown.value;
        }
        
    }
    return result;
}

//获取宽
-(CGFloat)lgb_GetWidth
{
    LGBLayoutManager *manager = [self lgb_GetLayoutManager];
    return [self lgb_GetWidthWithManager:manager];
}

-(CGFloat)lgb_GetWidthWithLayoutItem:(LGBLayoutItem *)item
{
    UIView *refView = item.view;
    CGFloat result = [refView lgb_GetWidth] * item.value;
    
    return result;
}

-(CGFloat)lgb_GetDirectWidthWithManager:(LGBLayoutManager *)manager
{
    CGFloat result = CGRectGetWidth(self.bounds);
    if (manager.width){
        if (manager.width.value == 0) {
            if ([self isKindOfClass:[UILabel class]] || [self isKindOfClass:[UITextView class]]) {//当width等于0时，自动计算label宽度
                CGSize size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, [self lgb_GetHeightWithManager:manager])];
                result = size.width;
            }else if ([self isKindOfClass:[UIImageView class]]){//当width等于0时，自动计算imageview宽度
                UIImage *img = ((UIImageView *)self).image;
                if (img) {
                    result = [self lgb_GetHeightWithManager:manager] * img.size.width / img.size.height;
                }else{
                    result = manager.width.value;
                }
            }else{
                result = manager.width.value;
            }

        }else{
            result = manager.width.value;
        }
        
    }else if (manager.ratioWidth){
        result = [self lgb_GetWidthWithLayoutItem:manager.ratioWidth];
    }else if (manager.ratio) {
        result = [self lgb_GetWidthWithLayoutItem:manager.ratio];
    }else if (manager.widthRatioToHeight){
        LGBLayoutItem *item = manager.widthRatioToHeight;
        result = item.value * [self lgb_GetHeight];
    }else if (manager.subviewsWidth){
        LGBLayoutItemRatio *item = manager.subviewsWidth;
        result = floorf(([item.view lgb_GetWidth] - item.value) / item.count);
//        DLOG(@"resutl:%f,%f,%f", result, item.value, item.count);
    }
    return result;
}

-(CGFloat)lgb_GetWidthWithManager:(LGBLayoutManager *)manager
{
    CGFloat result = 0;
    if (manager.right) { //右边距
        UIView *refView = manager.right.view;
        if (refView == self.superview) {
            result = [refView lgb_GetWidth] - manager.right.value - [self lgb_GetXWithManager:manager];
        }else{
            CGRect refRect = [self lgb_GetRectRefView:refView x:[refView lgb_GetX] width:0];
            result = CGRectGetMinX(refRect) - manager.right.value - [self lgb_GetXWithManager:manager];
        }
        
    }else if (manager.alignRight){//右对齐
        UIView *refView = manager.alignRight.view;
        CGFloat x = [refView lgb_GetX];
        CGFloat width = [refView lgb_GetWidth];
        if (refView.superview == self) {
            result = x + width - manager.alignRight.value;
        }else{
            CGRect refRect = [self lgb_GetRectRefView:refView x:x width:width];
            result = CGRectGetMaxX(refRect) - manager.alignRight.value - [self lgb_GetXWithManager:manager];
        }
        
    }else if (manager.arrayRight){
        LGBLayoutItemArray *item = manager.arrayRight;
        //寻找数组里面具有最大x坐标+宽的view
        for (UIView *v in item.views) {
            result = MAX(result, [v lgb_GetWidth] + [v lgb_GetX] - item.value);
        }
    }else{
        result = [self lgb_GetDirectWidthWithManager:manager];
    }
    return result;
}

//获取高
-(CGFloat)lgb_GetHeight
{
    LGBLayoutManager *manager =  [self lgb_GetLayoutManager];
    return [self lgb_GetHeightWithManager:manager];
}

-(CGFloat)lgb_GetHeightWithLayoutItem:(LGBLayoutItem *)item
{
    UIView *refView = item.view;
    CGFloat result = [refView lgb_GetHeight] * item.value;
    return result;
}

//此方法不包含manager.down和manager.alignDown条件
-(CGFloat)lgb_GetDirectHeightWithManager:(LGBLayoutManager *)manager
{
    CGFloat result = CGRectGetHeight(self.bounds);
    if (manager.height){
        if (manager.height.value == 0) {
            if ([self isKindOfClass:[UILabel class]] || [self isKindOfClass:[UITextView class]]) {//当height等于0时，自动计算label高度
                CGSize size = [self sizeThatFits:CGSizeMake([self lgb_GetWidthWithManager:manager], CGFLOAT_MAX)];
                result = size.height;
            }else if ([self isKindOfClass:[UIImageView class]]){//当height等于0时，自动计算imageview高度
                UIImage *img = ((UIImageView *)self).image;
                if (img) {
                    result = [self lgb_GetWidthWithManager:manager] * img.size.height / img.size.width;
                }else{
                    result = manager.height.value;
                }
            }else{
                result = manager.height.value;
            }

        }else{
            result = manager.height.value;
        }
        
    }else if (manager.ratioHeight){//高比例
        result = [self lgb_GetHeightWithLayoutItem:manager.ratioHeight];
    }else if (manager.ratio){//宽高比例
        result = [self lgb_GetHeightWithLayoutItem:manager.ratio];
    }else if (manager.heightRatioToWidth){
        LGBLayoutItem *item = manager.heightRatioToWidth;
        result = item.value * [self lgb_GetWidth];
    }else if (manager.subviewsHeight){ //子视图平均高度
        LGBLayoutItemRatio *item = manager.subviewsHeight;
        result = floorf(([item.view lgb_GetHeight] - item.value) / item.count);
    }
    
    return result;
}

-(CGFloat)lgb_GetHeightWithManager:(LGBLayoutManager *)manager
{
    CGFloat result = 0;
    if (manager.down) {
        UIView *refView = manager.down.view;
        if (refView == self.superview) {

            result = [refView lgb_GetHeight] - manager.down.value - [self lgb_GetYWithManager:manager];
            
        }else{

            CGRect refRect = [self lgb_GetRectRefView:refView y:[refView lgb_GetY] height:0];
            result = CGRectGetMinY(refRect) - manager.down.value - [self lgb_GetYWithManager:manager];
        }
    }else if (manager.alignDown){
        
        UIView *refView = manager.alignDown.view;
        CGFloat y = [refView lgb_GetY];
        CGFloat height = [refView lgb_GetHeight];
        if (refView.superview == self) {
            result = y + height - manager.alignDown.value;
        }else{
            CGRect refRect = [self lgb_GetRectRefView:refView y:y height:height];
            result = CGRectGetMaxY(refRect) - manager.alignDown.value - [self lgb_GetYWithManager:manager];
        }
   
    }else if (manager.arrayBottom){
        LGBLayoutItemArray *item = manager.arrayBottom;
        //寻找数组里面最大y坐标+高的view
        for (UIView *v in item.views) {
            result = MAX(result, [v lgb_GetHeight] + [v lgb_GetY] - item.value);
        }
    }else{
        result = [self lgb_GetDirectHeightWithManager:manager];
    }
    
    return result;
}

//添加子视图
-(void)lgb_AddSubviews:(NSArray *)subviews
{
    if (!subviews || subviews.count == 0) {
        return;
    }
    for (UIView *view in subviews) {
        [self addSubview:view];
    }
}

//设置scroll content size
-(void)lgb_SetScrollContentSize:(LGBLayoutManager *)manager
{
    if ([self isKindOfClass:[UIScrollView class]]) {

        if (manager.contentBottom) {
            
            UIScrollView *scroll = (UIScrollView *)self;
            LGBLayoutItem *item = manager.contentBottom;
            CGFloat width = [self lgb_GetWidth];
            CGFloat height = [item.view lgb_GetHeight] + [item.view lgb_GetY] - item.value;
            scroll.contentSize = CGSizeMake(width, height);
            
        }else if (manager.contentRight){
            
            UIScrollView *scroll = (UIScrollView *)self;
            LGBLayoutItem *item = manager.contentRight;
            CGFloat height = [self lgb_GetHeight];
            CGFloat width = [item.view lgb_GetWidth] + [item.view lgb_GetX] - item.value;
            scroll.contentSize = CGSizeMake(width, height);
            
        }
    }
}

//设置 Frame
-(void)lgb_SetFrameWithManager:(LGBLayoutManager *)manager
{
    if (!manager) {
        return;
    }
    [self lgb_SetX:[self lgb_GetXWithManager:manager]];
    [self lgb_SetY:[self lgb_GetYWithManager:manager]];
    [self lgb_SetWidth:[self lgb_GetWidthWithManager:manager]];
    [self lgb_SetHeight:[self lgb_GetHeightWithManager:manager]];
    
}

//设置子视图相等高度
-(void)lgb_SetEqualHeightSubviews:(NSArray *)subviews
{
    if (!subviews || subviews.count == 0) {
        return;
    }
    CGFloat space = 0;
    for (UIView *view in subviews) {
        LGBLayoutManager *manager = [view lgb_GetLayoutManager];
        if (manager) {
            if (manager.top) {
                space += manager.top.value;
            }
            if (manager.down) {
                space += manager.down.value;
            }
        }
    }

    for (UIView *view in subviews) {

        view.lgb_Layout.subviewsEqualToViewHeight(self, space, subviews.count);
    }
}

//设置子视图相等宽度
-(void)lgb_SetEqualWidthSubviews:(NSArray *)subviews
{
    if (!subviews || subviews.count == 0) {
        return;
    }
    CGFloat space = 0;
    for (UIView *view in subviews) {
        LGBLayoutManager *manager = [view lgb_GetLayoutManager];
        if (manager) {
            if (manager.left) {
                space += manager.left.value;
            }
            if (manager.right) {
                space += manager.right.value;
            }
        }
    }

    for (UIView *view in subviews) {
        view.lgb_Layout.subviewsEqualToViewWidth(self, space, subviews.count);
    }
}

//更新布局
-(void)lgb_UpdateLayout
{
    UIView *superView = self.superview;
    if (!superView) {
        superView = self;
    }
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];
}

//子视图布局
-(void)lgb_LayoutSubviews
{
    [self lgb_LayoutSubviews];
    [[self subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LGBLayoutManager *manager = [obj lgb_GetLayoutManager];
        if (manager) {
            [obj lgb_SetFrameWithManager:manager];
            [obj lgb_SetScrollContentSize:manager];
        }
    }];
}

//返回 layout manager
-(LGBLayoutManager *)lgb_Layout
{
    if (!self.superview) {
        @throw [[NSException alloc] initWithName:@"LGBLayout 出错了" reason:[NSString stringWithFormat:@"%@'s superview 不能为 nil", self] userInfo:nil];
    }
    
    LGBLayoutManager *manager = [self lgb_GetLayoutManager];
    if (!manager) {
        manager = [LGBLayoutManager new];
        objc_setAssociatedObject(self, &kLayoutManager, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return manager;
}

//获取 view 的 layout manager
-(LGBLayoutManager *)lgb_GetLayoutManager
{
    return objc_getAssociatedObject(self, &kLayoutManager);
}

@end
