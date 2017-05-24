//
//  UITableView+LGBCellHeight.h
//  AnimationCategory
//
//  Created by lgb789 on 2017/3/1.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 如果要自动布局，cell必须实现此协议
 */
@protocol LGBUITableViewCellHeightDelegate <NSObject>

/**
 添加数据到视图

 @param data 数据
 */
-(void)tableViewCellConfigData:(id)data;

@end

@interface UITableView (LGBCellHeight)

/**
 重新加载table view

 @param indexPaths 行
 */
-(void)lgb_ReloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/**
 计算cell高度

 @param cellClass cell类
 @param data 数据
 @param indexPath 行索引
 @return cell高度
 */
-(CGFloat)lgb_GetHeightOfCell:(Class<LGBUITableViewCellHeightDelegate>)cellClass
                         data:(id)data
                    indexPath:(NSIndexPath *)indexPath;

-(void)lgb_RemoveSavedCellHeightAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

-(void)lgb_RemoveSavedCellHeight;

@end
