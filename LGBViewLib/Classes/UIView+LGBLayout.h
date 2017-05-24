//
//  UIView+LGBLayout.h
//  AnimationCategory
//
//  Created by lgb789 on 2017/2/24.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGBLayoutManager;

typedef LGBLayoutManager* (^SpaceToView)(UIView *view, CGFloat value);
typedef LGBLayoutManager* (^SpaceToViewValue)(UIView *view);
typedef LGBLayoutManager* (^ValueIs)(CGFloat value);
typedef LGBLayoutManager* (^ValueIsABS)(void);
typedef LGBLayoutManager* (^CenterEqualToView)(UIView *view, CGFloat value);
typedef LGBLayoutManager* (^CenterCompleteEqualToView)(UIView *view);
typedef LGBLayoutManager* (^SizeRatioToView)(UIView *view, CGFloat value);
typedef LGBLayoutManager* (^AlignToView)(UIView *view, CGFloat value);
typedef LGBLayoutManager* (^AlignToViewValue)(UIView *view);
typedef LGBLayoutManager* (^ScrollContentAlignToView)(UIView *view, CGFloat value);
typedef LGBLayoutManager* (^AlignToViewArray)(NSArray *views, CGFloat value);
typedef LGBLayoutManager* (^WidthHeightEqual)(CGFloat value);

@interface LGBLayoutManager : NSObject
#pragma mark - ********************************************** 设置间距 **********************************************
/**
 设置view到左边view的距离，例如:.spaceToViewLeft(<左边view>， <距离>)
 */
@property (nonatomic, copy) SpaceToView spaceToViewLeft;

/**
 设置view到顶部view的距离，例如:.spaceToViewTop(<顶部view>， <距离>)
 */
@property (nonatomic, copy) SpaceToView spaceToViewTop;

/**
 设置view到右边view的距离，例如:.spaceToViewRight(<右边view>， <距离>)
 */
@property (nonatomic, copy) SpaceToView spaceToViewRight;

/**
 设置view到底部view的距离，例如:.spaceToViewDown(<底部view>， <距离>)
 */
@property (nonatomic, copy) SpaceToView spaceToViewDown;

#pragma mark - ********************************************** 设置绝对值 **********************************************
/**
 设置x坐标，例如:.isX(5)
 */
@property (nonatomic, copy) ValueIs isX;

/**
 设置y坐标，例如:.isY(5)
 */
@property (nonatomic, copy) ValueIs isY;

/**
 设置宽度，例如:.isWidth(10)。当宽度为0，并且view属于UILabel、UIImageView时，自适应计算宽度
 */
@property (nonatomic, copy) ValueIs isWidth;

/**
 设置高度，例如:.isHeight(10)。当高度为0，并且view属于UILabel、UIImageView时，自适应计算高度
 */
@property (nonatomic, copy) ValueIs isHeight;

#pragma mark - ********************************************** 设置中心点 **********************************************
/**
 设置view的中心点x坐标等于目标view的中心点x坐标加上偏移量，例如:.centerEqualToViewX(<目标view>, <偏移量>)
 */
@property (nonatomic, copy) CenterEqualToView centerEqualToViewX;

/**
 设置view的中心点y坐标等于目标view的中心点y坐标加上偏移量，例如:.centerEqualToViewY(<目标view>, <偏移量>)
 */
@property (nonatomic, copy) CenterEqualToView centerEqualToViewY;

/**
 设置view的中心点坐标等于目标view的中心点坐标，例如:.centerEqualToView(<目标view>)
 */
@property (nonatomic, copy) CenterCompleteEqualToView centerEqualToView;

#pragma mark - ********************************************** 设置大小 **********************************************
/**
 设置view的宽与目标view的宽的比例，例如:.sizeRatioToViewWidth(<目标view>, <比例>)
 */
@property (nonatomic, copy) SizeRatioToView sizeRatioToViewWidth;

/**
 设置view的高与目标view的高的比例，例如:.sizeRatioToViewHeight(<目标view>, <比例>)
 */
@property (nonatomic, copy) SizeRatioToView sizeRatioToViewHeight;

/**
 设置view的大小与目标view的大小的比例，例如:.sizeRatioToView(<目标view>, <比例>)
 */
@property (nonatomic, copy) SizeRatioToView sizeRatioToView;

@property (nonatomic, copy) WidthHeightEqual widthEqualToHeight;
@property (nonatomic, copy) WidthHeightEqual heightEqualToWidth;

#pragma mark - ********************************************** 设置对齐方式 **********************************************

/**
 设置view与目标view左对齐，即x坐标相等再加上偏移量，例如:.alignToViewLeft(<目标view>, <偏移量>)
 */
@property (nonatomic, copy) AlignToView alignToViewLeft;

/**
 设置view与目标view顶部对齐，即y坐标相等再加上偏移量，例如:.alignToViewTop(<目标view>, <偏移量>)
 */
@property (nonatomic, copy) AlignToView alignToViewTop;

/**
 设置view与目标view右对齐，再加上偏移量，例如:.alignToViewRight(<目标view>, <偏移量>)
 */
@property (nonatomic, copy) AlignToView alignToViewRight;

/**
 设置view与目标view底部对齐，再加上偏移量，例如:.alignToViewDown(<目标view>, <偏移量>)
 */
@property (nonatomic, copy) AlignToView alignToViewDown;

#pragma mark - ********************************************** 设置scroll view content size **********************************************

/**
 设置scroll view的content底部与目标view对齐，再加上偏移量，例如:.contentAlignToViewBottom(<目标view>, <偏移量>)
 */
@property (nonatomic, copy) ScrollContentAlignToView contentAlignToViewBottom;

/**
 设置scroll view的content右边与目标view对齐，再加上偏移量，例如:.contentAlignToViewRight(<目标view>, <偏移量>)
 */
@property (nonatomic, copy) ScrollContentAlignToView contentAlignToViewRight;

#pragma mark - ********************************************** 设置view宽高 **********************************************

/**
 设置view高度等于目标view数组中最大高度，再加上偏移量，例如:.alignToViewArrayBottom(<view数组>, <偏移量>)
 */
@property (nonatomic, copy) AlignToViewArray alignToViewArrayBottom;

/**
 设置view宽度等于目标view数组中最大宽度，再加上偏移量，例如:.alignToViewArrayRight(<view数组>, <偏移量>)
 */
@property (nonatomic, copy) AlignToViewArray alignToViewArrayRight;

#pragma mark - ******************************************** 固定值 ********************************************
@property (nonatomic, copy) SpaceToViewValue spaceToViewLeft_0p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewLeft_5p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewLeft_8p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewLeft_10p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewLeft_15p;

@property (nonatomic, copy) SpaceToViewValue spaceToViewTop_0p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewTop_5p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewTop_8p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewTop_10p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewTop_15p;

@property (nonatomic, copy) SpaceToViewValue spaceToViewRight_0p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewRight_5p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewRight_8p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewRight_10p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewRight_15p;

@property (nonatomic, copy) SpaceToViewValue spaceToViewDown_0p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewDown_5p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewDown_8p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewDown_10p;
@property (nonatomic, copy) SpaceToViewValue spaceToViewDown_15p;

@property (nonatomic, copy) AlignToViewValue alignToViewLeft_0p;
@property (nonatomic, copy) AlignToViewValue alignToViewLeft_5p;
@property (nonatomic, copy) AlignToViewValue alignToViewLeft_8p;
@property (nonatomic, copy) AlignToViewValue alignToViewLeft_10p;
@property (nonatomic, copy) AlignToViewValue alignToViewLeft_15p;

@property (nonatomic, copy) AlignToViewValue alignToViewTop_0p;
@property (nonatomic, copy) AlignToViewValue alignToViewTop_5p;
@property (nonatomic, copy) AlignToViewValue alignToViewTop_8p;
@property (nonatomic, copy) AlignToViewValue alignToViewTop_10p;
@property (nonatomic, copy) AlignToViewValue alignToViewTop_15p;

@property (nonatomic, copy) AlignToViewValue alignToViewRight_0p;
@property (nonatomic, copy) AlignToViewValue alignToViewRight_5p;
@property (nonatomic, copy) AlignToViewValue alignToViewRight_8p;
@property (nonatomic, copy) AlignToViewValue alignToViewRight_10p;
@property (nonatomic, copy) AlignToViewValue alignToViewRight_15p;

@property (nonatomic, copy) AlignToViewValue alignToViewDown_0p;
@property (nonatomic, copy) AlignToViewValue alignToViewDown_5p;
@property (nonatomic, copy) AlignToViewValue alignToViewDown_8p;
@property (nonatomic, copy) AlignToViewValue alignToViewDown_10p;
@property (nonatomic, copy) AlignToViewValue alignToViewDown_15p;

/**
 设置29point宽，用于table view 图标
 */
@property (nonatomic, copy) ValueIsABS isWidth_29p;

/**
 设置30point宽，用于tab bar图标
 */
@property (nonatomic, copy) ValueIsABS isWidth_30p;

/**
 设置94point宽，用于stepper
 */
@property (nonatomic, copy) ValueIsABS isWidth_94p;

/**
 设置270point宽，用于alter view
 */
@property (nonatomic, copy) ValueIsABS isWidth_270p;

/**
 设置51point宽，用于switch
 */
@property (nonatomic, copy) ValueIsABS isWidth_51p;

/**
 设置24potion宽，用于slider图标
 */
@property (nonatomic, copy) ValueIsABS isWidth_24p;

/**
 设置29point高，用于stepper、segment control
 */
@property (nonatomic, copy) ValueIsABS isHeight_29p;

/**
 设置44point高，用于tableview cell，toolbar，search bar，navigation bar
 */
@property (nonatomic, copy) ValueIsABS isHeight_44p;

/**
 设置31point高， 用于switch
 */
@property (nonatomic, copy) ValueIsABS isHeight_31p;

/**
 设置2point高，用于slider进度条
 */
@property (nonatomic, copy) ValueIsABS isHeight_2p;

/**
 设置30point高，用于slider thumb，tab bar图标
 */
@property (nonatomic, copy) ValueIsABS isHeight_30p;

/**
 设置217point高， 用于picker view
 */
@property (nonatomic, copy) ValueIsABS isHeight_217p;


/**
 设置49point高，用于tab bar
 */
@property (nonatomic, copy) ValueIsABS isHeight_49p;

/**
 设置20point高，用于状态栏
 */
@property (nonatomic, copy) ValueIsABS isHeight_20p;

/**
 设置24point高，用于slider图标
 */
@property (nonatomic, copy) ValueIsABS isHeight_24p;

/**
 设置57point高，用于action sheet按钮
 */
@property (nonatomic, copy) ValueIsABS isHeight_57p;

/**
 设置36point高，用于edit menu
 */
@property (nonatomic, copy) ValueIsABS isHeight_36p;
@end












@interface UIView (LGBLayout)

/**
 获取视图x坐标

 @return x坐标
 */
-(CGFloat)lgb_GetX;

/**
 获取视图y坐标

 @return y坐标
 */
-(CGFloat)lgb_GetY;

/**
 获取视图的宽度

 @return 视图宽度
 */
-(CGFloat)lgb_GetWidth;

/**
 获取视图的高度

 @return 视图高度
 */
-(CGFloat)lgb_GetHeight;

/**
 添加子视图

 @param subviews 子视图
 */
-(void)lgb_AddSubviews:(NSArray *)subviews;

/**
 设置子视图的高度相当

 @param subviews 子视图
 */
-(void)lgb_SetEqualHeightSubviews:(NSArray *)subviews;

/**
 设置子视图的宽度相等

 @param subviews 子视图
 */
-(void)lgb_SetEqualWidthSubviews:(NSArray *)subviews;

/**
 返回布局管理对象, 可以通过此对象添加布局条件

 @return 布局管理对象
 */
-(LGBLayoutManager *)lgb_Layout;

/**
 刷新视图布局
 */
-(void)lgb_UpdateLayout;
@end
