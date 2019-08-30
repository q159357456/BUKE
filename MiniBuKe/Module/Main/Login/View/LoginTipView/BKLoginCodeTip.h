//
//  BKLoginCodeTip.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKLoginCodeTip : NSObject

- (void)AddCodeSendOkTip:(UIView*)view;
- (void)AddCodeIsErrorTip:(UIView*)view;
- (void)AddLoginNetErrorTip:(UIView*)view;
- (void)AddFeedbackOkTip:(UIView*)view;
- (void)codeInvalidTip:(UIView*)view Info:(NSString*)info;
- (void)ActivicodeSuccess:(UIView*)view;
- (void)AddLoginRequestErrorTip:(UIView*)view;

- (void)AddBindWeChartOkTip:(UIView*)view;
- (void)AddBindWeChartFailTip:(UIView*)view;

- (void)AddTextShowTip:(NSString*)tipStr and:(UIView*)view;

@end

NS_ASSUME_NONNULL_END
