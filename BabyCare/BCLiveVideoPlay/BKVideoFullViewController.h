//
//  BKVideoFullViewController.h
//  babycaretest
//
//  Created by Don on 2019/4/24.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKVideoFullViewController : UIViewController
//释放监听通知
- (void)releaseNotific;
//添加监听通知
- (void)addNotific;

@end

NS_ASSUME_NONNULL_END
