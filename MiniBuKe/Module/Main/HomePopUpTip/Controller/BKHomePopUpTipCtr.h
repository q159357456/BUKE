//
//  BKHomePopUpTipCtr.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKHomePopUpTipCtr : UIViewController
/**弹出提示*/
-(void)startShowTipWithController:(UIViewController*)controller;
/**设置tip*/
-(void)showWithTitle:(NSString*)titleStr andsubTitle:(NSString*)subTitle andBtntitel:(NSString*)btnTitle andContent:(NSString*)content andImageName:(NSString*)imageName andIsTap:(BOOL)istap andIsFullPic:(BOOL)isFullPic AndBtnAction:(void(^)(void))BtnAction;
- (void)dissMissCtr;

@end

NS_ASSUME_NONNULL_END
