//
//  TalkKeybord.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TalkKeybordDelegate<NSObject>

@optional
-(void)clickSendEmoji:(UIButton *)sender;

@end

@interface TalkKeybord : UIView

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic, assign) id<TalkKeybordDelegate> delegate;

@end
