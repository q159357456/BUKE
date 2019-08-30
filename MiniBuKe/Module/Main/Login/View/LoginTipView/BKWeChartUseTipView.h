//
//  BKWeChartUseTipView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKWeChartUseTipView : UIView

@property (nonatomic, copy) void(^okBtnClick)(void);

- (void)setTitleWithNumber:(NSString*)number;

@end

NS_ASSUME_NONNULL_END
