//
//  QLVideoNoWiFiTipView.h
//  QLMediaPlayer
//
//  Copyright © 2019年 Don. All rights reserved.
//
//无wifi提示界面
#import <UIKit/UIKit.h>

@protocol QLVideoNoWiFiTipViewDelegate <NSObject>
//继续播放
-(void)VideoNoWiFiTipGoPlay;
//取消播放
-(void)VideoNoWiFiTipCancelPlay;

@end

@interface QLVideoNoWiFiTipView : UIView

@property(assign,nonatomic)id<QLVideoNoWiFiTipViewDelegate>delegate;


@end
