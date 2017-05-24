//
//  UITableView+LGBCellHeight.m
//  AnimationCategory
//
//  Created by lgb789 on 2017/3/1.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#import "UITableView+LGBCellHeight.h"
#import <objc/runtime.h>
#import "UIView+LGBLayout.h"

static void *kHeightDic;

static const NSString *kCellWidth = @"kCellWidth";
static const NSString *kCurrentOrientation = @"kCurrentOrientation";

@implementation UITableView (LGBCellHeight)

-(NSMutableDictionary *)lgb_GetHeightsDic
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &kHeightDic);
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &kHeightDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

-(void)lgb_ReloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    NSMutableDictionary *dic = [self lgb_GetHeightsDic];
    for (NSIndexPath *indexPath in indexPaths) {
        NSString *key = [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row];
        [dic removeObjectForKey:key];
    }
//    [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation]; //这个方法有残影
    [self reloadData];
}

-(void)lgb_RemoveSavedCellHeightAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    NSMutableDictionary *dic = [self lgb_GetHeightsDic];
    for (NSIndexPath *indexPath in indexPaths) {
        NSString *key = [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row];
        [dic removeObjectForKey:key];
    }
}

-(void)lgb_RemoveSavedCellHeight
{
    NSMutableDictionary *dic = [self lgb_GetHeightsDic];
    [dic removeAllObjects];
}

-(CGFloat)lgb_GetHeightOfCell:(Class<LGBUITableViewCellHeightDelegate>)cellClass data:(id)data indexPath:(NSIndexPath *)indexPath
{
//    DLOG(@"table width:%f,%ld", CGRectGetWidth(self.bounds), (long)[UIDevice currentDevice].orientation);
    
    NSMutableDictionary *dic = [self lgb_GetHeightsDic];
    //横竖屏切换
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    id objOrientation = [dic objectForKey:kCurrentOrientation];
    if (objOrientation) {
        UIDeviceOrientation currOrientation = [objOrientation integerValue];
        if (orientation != currOrientation) {
            [dic removeAllObjects];
            [dic setObject:@(currOrientation) forKey:kCurrentOrientation];
//            dic = nil;
//            objc_setAssociatedObject(self, &kHeightDic, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }else{
        [dic setObject:@(orientation) forKey:kCurrentOrientation];
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row];
    
    id obj = [dic objectForKey:key];
    if (obj) {
        return [obj floatValue];
    }
    CGFloat height = 0;
    NSString *identifier = [NSString stringWithFormat:@"__LGB_%@", NSStringFromClass(cellClass)];
    UITableViewCell<LGBUITableViewCellHeightDelegate> *cell = [self dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        [self registerClass:cellClass forCellReuseIdentifier:identifier];
        cell = [self dequeueReusableCellWithIdentifier:identifier];
    }
    [cell tableViewCellConfigData:data];
    
    //视图初始化时cell固定宽度为320，导致计算label高度出错，所以在这里设定cell宽度为table宽度
    CGFloat cellWidth = 0;
    id widthObj = [dic objectForKey:kCellWidth];
    if (widthObj) {
        cellWidth = [widthObj floatValue];
    }else{
        cellWidth = [self lgb_GetWidth];
        [dic setObject:@(cellWidth) forKey:kCellWidth];
    }
    CGRect frame = cell.frame;
    frame.size.width = [self lgb_GetWidth];
    cell.frame = frame;
    
    height = [cell.contentView lgb_GetHeight];
    
    [dic setObject:@(height) forKey:key];
//    DLOG(@"heigth:%f, %@", height, NSStringFromCGRect(self.frame));
    
    return height;
}

@end
