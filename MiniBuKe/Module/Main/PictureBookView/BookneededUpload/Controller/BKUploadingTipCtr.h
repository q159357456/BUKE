//
//  BKUploadingTipCtr.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/15.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKUploadingTipCtr : UIViewController

- (instancetype)initWithTitle:(NSString*)title andDes:(NSString*)des andleftBtnTitle:(NSString*)leftBtnTitle andrightBtnTitle:(NSString*)rightBtnTitle andIconName:(NSString*)iconName;

@property (nonatomic, copy) void(^uploadTipLeftBtnClick)();
@property (nonatomic, copy) void(^uploadTipRightBtnClick)();

@end

NS_ASSUME_NONNULL_END
