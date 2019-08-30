//
//  BKLoginCodeInputView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKLoginCodeInputView : UIView
-(void)startFirstResponder;
-(void)cancelFirstResponder;

-(void)changeSendCodeBtnUIWithEnabel:(BOOL)isEnabel;

@property (nonatomic, copy) void(^sendCodeBtnClick)(void);

/**开启60S倒计时操作*/
-(void)beginStartCountDown;

@end

NS_ASSUME_NONNULL_END
