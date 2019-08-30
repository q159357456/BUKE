//
//  TalkViewController.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkViewController : UIViewController

@property(nonatomic,copy) NSArray *observeArray;
@property(nonatomic,copy)void(^forbidBlock)(BOOL scroPremission);
//收到消息回调
@property(nonatomic,copy)void(^receiveMessageBlock)(void);
//停止播放动画
-(void)stopVoiceAnimationing;
//停止播放
-(void)stopPlay;
@end
