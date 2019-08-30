//
//  ARLockView.h
//  MiniBuKe
//
//  Created by chenheng on 2019/5/13.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARAudioManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface ARLockView : UIView
@property(nonatomic,assign)NSInteger random;
+(instancetype)showLockInfoCallBack:(void(^)(void))block;
+(void)stopAR;
@end

NS_ASSUME_NONNULL_END
