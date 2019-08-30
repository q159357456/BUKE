//
//  BKNetWorkErrorBackView.h
//  MiniBuKe
//
//  Created by chenheng on 2019/2/19.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKNetWorkErrorBackView : UIView

@property (nonatomic, copy) void(^tryAgainAction)(void);

+(instancetype)showOn:(UIView*)view WithFrame:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
