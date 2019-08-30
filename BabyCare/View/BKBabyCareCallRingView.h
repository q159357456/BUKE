//
//  BKBabyCareCallRingView.h
//  MiniBuKe
//
//  Created by chenheng on 2019/5/5.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKBabyCareCallRingView : UIView

@property (nonatomic, copy) void(^BtnClick)(BOOL isAccecpt);

@end

NS_ASSUME_NONNULL_END
