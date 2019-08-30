//
//  BKLoadAnimationView.h
//  MiniBuKe
//
//  Created by chenheng on 2019/2/18.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKLoadAnimationView : UIView
+(void)ShowHit;
+(void)Hidden;
+(void)ShowHitOn:(UIView*)view;
+(void)ShowHitOn:(UIView *)view Frame:(CGRect)rect;
+(void)HiddenFrom:(UIView*)view;
@end

NS_ASSUME_NONNULL_END
