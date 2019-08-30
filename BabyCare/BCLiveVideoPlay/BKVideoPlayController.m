//
//  BKVideoPlayController.m
//  babycaretest
//
//  Created by Don on 2019/4/24.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKVideoPlayController.h"
#import "BKCameraManager.h"
#import "QLVideoNoWiFiTipView.h"
#import "AFNetworkReachabilityManager.h"


@interface BKVideoPlayController ()<BKVideoPlayViewDelegate,QLVideoNoWiFiTipViewDelegate>

@property (nonatomic, strong) UIViewController * ownCtr;
//小窗模式的frame
@property(nonatomic,assign)CGRect videoSmallFrame;
//全屏控制器
@property(nonatomic,strong) BKVideoFullViewController *fvc;

/* 工具栏的显示和隐藏 */
@property (nonatomic, weak) NSTimer *showTimer;
/* 工具栏展示的时间 */
@property (assign, nonatomic) NSTimeInterval showTime;


@property (nonatomic, assign) BOOL isPlay;

@property (nonatomic, strong) QLVideoNoWiFiTipView *wifiTipView;

@end

@implementation BKVideoPlayController
- (BOOL)shouldAutorotate{
    return NO;
}
+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance =  [[BKVideoPlayController alloc] init];
    });
    return instance;
}

- (void)setThePlayViewWithFrame:(CGRect)frame andView:(UIView*)playSuperView andController:(UIViewController*)ctr{
    self.videoSmallFrame = frame;
    self.ownCtr = ctr;
    self.playView.frame = self.videoSmallFrame;
    self.playView.delegate = self;
    [playSuperView addSubview:self.playView];
    //开始监测网络变化
    [self afnReachabilityCheckStart];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - lazy
- (BKVideoPlayView *)playView{
    if (!_playView) {
        _playView = [[BKVideoPlayView alloc]init];
        _playView.delegate = self;
    }
    return _playView;
}

- (BKVideoFullViewController*)fvc{
    if (!_fvc) {
        _fvc = [[BKVideoFullViewController alloc]init];
    }
    return _fvc;
}

#pragma mark - playView delegate
- (void)playViewSwitchOrientationWithIsFull:(BOOL)isFull{
    [self CtrplayViewSwitchOrientation:isFull];
}
- (void)playViewFrameHasChanged{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BKVideoViewHasChanged)]) {
        [self.delegate BKVideoViewHasChanged];
    }
}
- (void)playViewSnapClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BKVideoViewSnapClick)]) {
        [self.delegate BKVideoViewSnapClick];
    }
}

- (void)playViewBackBtnClick {

    if (self.delegate && [self.delegate respondsToSelector:@selector(BKVideoViewBackClick)]) {
        [self.delegate BKVideoViewBackClick];
    }
}

- (void)playViewPlayBtnClikWithIsOpen:(BOOL)isOpen {
    if (self.playView.isFullView) {
        [self addShowTimer];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(BKVideoViewPlay:)]) {
        [self.delegate BKVideoViewPlay:isOpen];
    }
}

- (void)playViewTalkClickWithIsOpen:(BOOL)isOpen {
    if (self.playView.isFullView) {
        [self addShowTimer];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(BKVideoViewTalk:)]) {
        [self.delegate BKVideoViewTalk:isOpen];
    }
}

- (void)playViewVolumeClickWithIsOpen:(BOOL)isOpen {
    if (self.playView.isFullView) {
        [self addShowTimer];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(BKVideoViewVolume:)]) {
        [self.delegate BKVideoViewVolume:!isOpen];
    }
}

- (void)playFullViewTap:(BOOL)isShow{
    [self.playView showToolView:isShow];
    if (isShow) {
        [self addShowTimer];
    }else{
        [self removeShowTimer];
    }
}

- (void)playViewMenuBtnClick:(UIButton*)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BKVideoViewMenuClick:)]) {
        [self.delegate BKVideoViewMenuClick:btn];
    }
}

#pragma mark - QLVideoNoWiFiTipViewDelegate
- (void)VideoNoWiFiTipGoPlay{
    [self removeNoWifiTipView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(BKVideoNetHasChangeWWANGoPlay)]) {
        [self.delegate BKVideoNetHasChangeWWANGoPlay];
    }
}
- (void)VideoNoWiFiTipCancelPlay{
    [self removeNoWifiTipView];
    self.isPlay = NO;
    [self changeTheVideoPlayStateWithIsShow:self.isPlay];
}
#pragma mark - 全屏切换
//全屏切换
- (void)CtrplayViewSwitchOrientation:(BOOL)isFull{
    
    if (isFull) {//切换到全屏
        [self.ownCtr.navigationController pushViewController:self.fvc animated:NO];
        [self.playView removeFromSuperview];
        [self.fvc.view addSubview:self.playView];
        self.playView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        self.fvc.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        self.playView.transform = CGAffineTransformRotate(self.playView.transform, M_PI*1.5);
        [UIView animateWithDuration:0.3 animations:^{
            self.playView.transform = CGAffineTransformRotate(self.playView.transform, M_PI*-1.5);
        }];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];

        [self.fvc addNotific];
        
        [self playFullViewTap:YES];

    }else{//取消全屏
        [self removeShowTimer];
        [self.playView showToolView:YES];
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];

        [self.fvc releaseNotific];
        
        [self.ownCtr.navigationController popViewControllerAnimated:NO];
        
        [self.playView removeFromSuperview];
        self.playView.frame = CGRectMake(0, 0, self.videoSmallFrame.size.width, self.videoSmallFrame.size.height);
        
        self.playView.frame = CGRectMake(CGRectGetMinX(self.videoSmallFrame)+([UIScreen mainScreen].bounds.size.width-CGRectGetHeight(self.videoSmallFrame))*0.5, CGRectGetMinY(self.videoSmallFrame), CGRectGetHeight(self.videoSmallFrame), CGRectGetHeight(self.videoSmallFrame));
        [_ownCtr.view addSubview:self.playView];
        
        self.playView.transform = CGAffineTransformRotate(self.playView.transform, M_PI*-1.5);
        [UIView animateWithDuration:0.3 animations:^{
            self.playView.transform = CGAffineTransformRotate(self.playView.transform, M_PI*1.5);
            self.playView.frame = CGRectMake(0, 0, self.videoSmallFrame.size.width, self.videoSmallFrame.size.height);
            ;
        }];
    }
    
    self.playView.isFullView = isFull;
}
#pragma mark - 定时器
//播放器界面按钮自动隐藏 5S自动隐藏 相关的定时器方法下面三个
- (void)addShowTimer
{
    [self removeShowTimer];
    self.showTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateShowTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.showTimer forMode:NSRunLoopCommonModes];
}
- (void)removeShowTimer
{
    [self.showTimer invalidate];
    self.showTimer = nil;
    self.showTime = 0;
}
- (void)updateShowTime
{
    self.showTime += 1;
    if (self.showTime > 4.0) {
        [self playFullViewTap:NO];
    }
}

#pragma mark - public
- (void)changeTheUIActivityIndicatorViewState:(BOOL)isLoading{
    [self.playView ActionLoadingChange:isLoading];
}
/**播放通话状态同步*/
- (void)changeTheVideoPlayStateWithIsShow:(BOOL)isShow{
    [self.playView changeTheUIStateWithIsShow:isShow];
    self.isPlay = isShow;
}
- (void)changeTheVideoPlayStateWithIsLising:(BOOL)isListen{
    [self.playView changeTheUIStateWithIsLising:isListen];
}
- (void)changeTheVideoPlayStateWithIsTalk:(BOOL)isTalk{
    [self.playView changeTheUIStateWithIsTalk:isTalk];
}

#pragma mark - networkcheck
- (void)afnReachabilityCheckStart {
    __weak typeof (self) weakSelf = self;

    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 一共有四种状态
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable://无网络
                NSLog(@"AFNetworkReachability Not Reachable");
                weakSelf.myNetworkState = BKNewWorkState_NoNetwork;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN://流量
                NSLog(@"AFNetworkReachability Reachable via WWAN");
                weakSelf.myNetworkState = BKNewWorkState_WWAN;
                if (weakSelf.isPlay && [weakSelf.playView GetThePlayBtnhide] && [BKCameraManager shareInstance].deviceState == DeviceContentStateType_onLine && [BKCameraManager shareInstance].isVideoShow) {
                    [weakSelf networkHasChange];
                }

                break;
            case AFNetworkReachabilityStatusReachableViaWiFi://wifi
                NSLog(@"AFNetworkReachability Reachable via WiFi");
                weakSelf.myNetworkState = BKNewWorkState_Wifi;
                if ([BKCameraManager shareInstance].deviceState == DeviceContentStateType_onLine) {
                    [weakSelf networkHasChange];
                }

                break;
            case AFNetworkReachabilityStatusUnknown:
            default:
                NSLog(@"AFNetworkReachability Unknown");
                weakSelf.myNetworkState = BKNewWorkState_NoNetwork;
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)afnReachabilityCheckStop {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)networkHasChange{
    if(self.myNetworkState == BKNewWorkState_WWAN){
        if (self.delegate && [self.delegate respondsToSelector:@selector(BKVideoNetHasChangeWWANStopPlay)]) {
            [self.delegate BKVideoNetHasChangeWWANStopPlay];
            [self addNoWifTipView];
        }
    }else{
        if (self.wifiTipView.superview) {
            [self.wifiTipView removeFromSuperview];
        }
    }
}

//添加无wifi提示
- (void)addNoWifTipView{
    [self.wifiTipView removeFromSuperview];
    if (self.wifiTipView == nil) {
        self.wifiTipView = [[QLVideoNoWiFiTipView alloc]init];
        self.wifiTipView.frame = self.playView.frame;
        self.wifiTipView.delegate = self;
    }
    [self.playView addSubview:self.wifiTipView];
}

- (void)removeNoWifiTipView{
    [self.wifiTipView removeFromSuperview];
}

-(void)dealloc{
    [self afnReachabilityCheckStop];
}

@end
