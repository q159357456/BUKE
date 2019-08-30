//
//  BabyInfoTapChosenView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BabyInfoTapChosenView_Event @"BabyInfoTapChosenView_Event"
#define BabyInfoTapClick_Event @"BabyInfoTapClick"
NS_ASSUME_NONNULL_BEGIN

@interface BabyInfoTapChosenView : UIView
/** 标签名字数组 */
@property (nonatomic, strong) NSArray *tagsArray;
/** 标签frame数组 */
@property (nonatomic, strong) NSMutableArray *tagsFrames;
/** 全部标签的高度 */
@property (nonatomic, assign) CGFloat tagsHeight;
/** 标签间距 default is 10*/
@property (nonatomic, assign) CGFloat tagsMargin;
/** 标签行间距 default is 10*/
@property (nonatomic, assign) CGFloat tagsLineSpacing;
/** 标签最小内边距 default is 10*/
@property (nonatomic, assign) CGFloat tagsMinPadding;
/** 宽度 */
@property(nonatomic,assign)CGFloat width;
/** 开始坐标X*/
@property(nonatomic,assign)CGFloat startX;
/** 开始坐标y*/
@property(nonatomic,assign)CGFloat startY;
-(void)selectTemp:(NSString*)param;
@end

NS_ASSUME_NONNULL_END
