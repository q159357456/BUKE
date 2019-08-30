//
//  BKSettingCancelBindTip.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKSettingCancelBindTip : UIView

@property (nonatomic, copy) void(^leftBtnClick)(void);
@property (nonatomic, copy) void(^rightBtnClick)(void);

- (void)setTitle:(NSString*)titleStr andsubTitle:(NSString*)subTitle andLeftBtntitel:(NSString*)leftTitle andRightBtnTitle:(NSString*)rightTitle;

@end

NS_ASSUME_NONNULL_END

