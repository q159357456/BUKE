//
//  BKuploadTipView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/15.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKuploadTipView : UIView

- (void)setTitle:(NSString*)title des:(NSString*)des andImage:(NSString*)iconstr andLeftBtnTitle:(NSString*)leftTitle andRightBtnTitle:(NSString*)rightTitle;

@property (nonatomic, copy) void(^leftBtnClick)();
@property (nonatomic, copy) void(^rightBtnClick)();

@end

NS_ASSUME_NONNULL_END
