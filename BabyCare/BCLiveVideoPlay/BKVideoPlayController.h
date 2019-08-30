//
//  BKVideoPlayController.h
//  babycaretest
//
//  Created by Don on 2019/4/24.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKVideoPlayView.h"
#import "BKVideoFullViewController.h"

typedef enum BKNewWorkState {
    BKNewWorkState_NoNetwork = 1,//无网络
    BKNewWorkState_Wifi  = 2,//wifiz
    BKNewWorkState_WWAN = 3//移动网络
} BKNewWorkState;
NS_ASSUME_NONNULL_BEGIN

@protocol BKVideoPlayControllerDelegate <NSObject>

@optional
//大小屏切换view frame 改变
- (void)BKVideoViewHasChanged;
//屏幕截屏点击
- (void)BKVideoViewSnapClick;
//播放按钮代理
- (void)BKVideoViewPlay:(BOOL)isPlay;
//声音按钮代理
- (void)BKVideoViewVolume:(BOOL)isClose;
//通话按钮代理
- (void)BKVideoViewTalk:(BOOL)isTalk;
//菜单按钮点击代理
- (void)BKVideoViewMenuClick:(UIButton*)btn;
//返回按钮代理
- (void)BKVideoViewBackClick;
//流量提示,点击停止播放代理
- (void)BKVideoNetHasChangeWWANStopPlay;
//流量提示,点击继续播放打理
- (void)BKVideoNetHasChangeWWANGoPlay;

@end

@interface BKVideoPlayController : UIViewController

@property (nonatomic, assign) id<BKVideoPlayControllerDelegate>delegate;

//播放器界面view
@property (strong, nonatomic) BKVideoPlayView *playView;
@property (nonatomic, assign) BKNewWorkState myNetworkState;

+ (instancetype)shareInstance;

/**初始化播放器设置*/
- (void)setThePlayViewWithFrame:(CGRect)frame andView:(UIView*)playSuperView andController:(UIViewController*)ctr;

/**播放loading状态改变*/
- (void)changeTheUIActivityIndicatorViewState:(BOOL)isLoading;
/**播放通话状态同步*/
- (void)changeTheVideoPlayStateWithIsShow:(BOOL)isShow;
- (void)changeTheVideoPlayStateWithIsLising:(BOOL)isListen;
- (void)changeTheVideoPlayStateWithIsTalk:(BOOL)isTalk;

- (void)networkHasChange;

@end

NS_ASSUME_NONNULL_END
