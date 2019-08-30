//
//  BKMessageCtr.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKMessageCtr : UIViewController
@property (nonatomic, copy) void(^ChangeRedTip)(BOOL isRed);

@end

NS_ASSUME_NONNULL_END
