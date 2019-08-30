//
//  BKTixianWeChartTipCtr.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKDepsitTipWeChartView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKTixianWeChartTipCtr : UIViewController

@property (nonatomic, strong) BKDepsitTipWeChartView *tipView;

- (void)setUIWithImageUrl:(NSString*)url andNameStr:(NSString*)nameStr andTitleStr:(NSString*)titleStr andBtnStr:(NSString*)btnStr;

@property (nonatomic, copy) void(^ClickDoneBtn)(void);

@end

NS_ASSUME_NONNULL_END