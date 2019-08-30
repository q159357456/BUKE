//
//  PBBaseViewControllerHelp.h
//  PictureBook
//
//  Created by Don on 2018/5/15.
//  Copyright © 2018年 Don. All rights reserved.
//

#ifndef PBBaseViewControllerHelp_h
#define PBBaseViewControllerHelp_h

/*!
 上拉刷新和下拉刷新支持
 */
@protocol P_QLDragToRefresh <NSObject>

@required

- (UIScrollView *)dragRefreshView;
- (BOOL)hasHeaderDragRefresh;
- (BOOL)hasFootterDragRefresh;

@optional
/* 拖拽刷新
 @param bMore YES:上拉刷新，加载下一页  NO:下拉刷新页面
 */
- (void)dragReload:(BOOL)bMore;

@end

#endif /* PBBaseViewControllerHelp_h */
