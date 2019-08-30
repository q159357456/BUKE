//
//  BKHomePopView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKHomePopView : UIView
-(void)setUpTitle:(NSString*)titleStr andsubTitle:(NSString*)subTitle andBtntitel:(NSString*)btnTitle andImageName:(NSString*)imageName andContent:(NSString*)content andIsFullPic:(BOOL)isFullPic;

@property (nonatomic, copy) void(^BtnClick)(void);

@end

NS_ASSUME_NONNULL_END
