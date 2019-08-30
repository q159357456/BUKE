//
//  BKCommonShowTipCtr.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/6.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKCommonShowTipCtr : UIViewController
/**设置tip*/
-(void)showWithTitle:(NSString*)titleStr andsubTitle:(NSString*)subTitle andLeftBtntitel:(NSString*)leftTitle andRightBtnTitle:(NSString*)rightTitle andIsTap:(BOOL)istap AndLeftBtnAction:(void(^)(void))LeftAction AndRightBtnAction:(void(^)(void))rightAction;
/**弹出提示*/
-(void)startShowTipWithController:(UIViewController*)controller;

@end

NS_ASSUME_NONNULL_END
