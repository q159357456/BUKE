//
//  BKBabyCareMainCtr.m
//  MiniBuKe
//
//  Created by Don on 2019/4/28.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBabyCareMainCtr.h"
#import <IOTCamera/IOTCamera.h>
#import <AVFoundation/AVFoundation.h>
#import "BKCameraManager.h"
#import <Photos/Photos.h>
#import "BKVideoPlayController.h"
#import "BKBabyCareMenuPopView.h"
#import "BKConfigAddressBookCtr.h"
#import "BKCallRecordViewController.h"
#import "BKDeviceManagnerCtr.h"
#import "BKBabyCareCallRingView.h"
#import "BKCommonShowTipCtr.h"
#import "QRCodeViewController.h"
#import "XYDMSetting.h"
#import "MusicPlayTool.h"
@interface BKBabyCareMainCtr ()<BKCameraManagerDelegtae,BKVideoPlayControllerDelegate,BKBabyCareMenuPopViewDelegate>

@property (nonatomic, strong) UIButton *bigTalkBtn;//通话按钮
@property (nonatomic, assign) BOOL isEnableTalk;
@property (nonatomic, strong) UILabel *TalkShowTitle;
@property (nonatomic, strong) UILabel *TalkShowsubTitle;
@property (nonatomic, assign) BOOL isPopCtr;
@property (nonatomic, assign) NSInteger viewShowCount;

@property (nonatomic, assign) BOOL isCancelTalkContent;//是否已经取消通话
@property (nonatomic ,strong) BKBabyCareMenuPopView *popView;//功能菜单弹窗
@property (nonatomic, assign) NSInteger  AutomCallIndex; //是否是APP主动打电话
@property (nonatomic, assign) BOOL isMaster; //是否有通讯录身份

@end

@implementation BKBabyCareMainCtr
-(void)closeOtherAudio{
    //关掉喜马拉雅播放器
    if ([XYDMSetting IsPlaying]) {
        [XYDMSetting pause];
    }
    //关掉播放器
    if ([MusicPlayTool shareMusicPlay].isPlaying) {
        [[MusicPlayTool shareMusicPlay] musicPause];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

    //屏幕常量
    [UIApplication sharedApplication].idleTimerDisabled =YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [BKCameraManager shareInstance].isInManagerView = YES;
    self.viewShowCount += 1;
    
    if (self.noticModel != nil) {
        self.AutomCallIndex += 1;
    }

    [self contentITO];
    
    if(!self.isMaster){
        [XBKNetWorkManager requestFetchContactsListWithSN:APP_DELEGATE.snData.sn AndAndFinish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            if (error == nil) {
                NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
                if (code == 1) {
                    NSArray *array = [responseObj objectForKey:@"data"];
                    for (NSDictionary *data in array) {
                        if (1 == [[data objectForKey:@"isMaster"] integerValue]) {
                            self.isMaster = YES;
                            break;
                        }
                    }
                    NSLog(@"身份 -%d",self.isMaster);
                }
            }
        }];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    

    
    [[BKVideoPlayController shareInstance].playView changeTheContentStateShowLabel:[self checkTheContentStateIsOnLine] andIsShow:![BKCameraManager shareInstance].isVideoShow];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //取消屏幕常量
    [UIApplication sharedApplication].idleTimerDisabled =NO;
    [BKCameraManager shareInstance].isInManagerView = NO;
    [BKCameraManager shareInstance].talkStepflag = -1;
    
    if(![BKVideoPlayController shareInstance].playView.isFullView ){
        if ([BKCameraManager shareInstance].isVideoShow) {
            [[BKCameraManager shareInstance] StopShowVideo];
            [[BKVideoPlayController shareInstance] changeTheVideoPlayStateWithIsShow:NO];
            [[BKVideoPlayController shareInstance] changeTheUIActivityIndicatorViewState:NO];
        }
        if (self.isPopCtr) {
            [[BKVideoPlayController shareInstance].playView defaultSetShowView];
            self.isPopCtr = NO;
            self.AutomCallIndex = 0;
        }
    }
}

- (void)contentITO{
    [BKCameraManager shareInstance].managerDelegate = self;

    if ([BKCameraManager shareInstance].deviceState != DeviceContentStateType_onLine) {
        //连接
        [[BKCameraManager shareInstance] ConnectDevice];
    }else{
        if (self.AutomCallIndex == 1) {
            [self automCallTheDevice];
        }
    }
    
    if (self.viewShowCount == 1) {
        [[BKVideoPlayController shareInstance].playView changeTheContentStateShowLabel:[self checkTheContentStateIsOnLine] andIsShow:YES];
    }
}

- (void)automCallTheDevice{
    [[BKCameraManager shareInstance] answerTheDeviceTalk];
    [self BKVideoViewPlay:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[BKVideoPlayController shareInstance].playView changeTheContentStateShowLabel:[self checkTheContentStateIsOnLine] andIsShow:![BKCameraManager shareInstance].isVideoShow];

        [[BKCameraManager shareInstance] AnswerTalkToDevice];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self stepUI];
    [self changeThebigTalkBtnEnable:NO];
}

- (void)stepUI{
    
    [[BKVideoPlayController shareInstance] setThePlayViewWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.width/(1280/960.f)) andView:self.view andController:self];
    [BKVideoPlayController shareInstance].delegate = self;
    
    self.bigTalkBtn = [[UIButton alloc]init];
    [self.bigTalkBtn setImage:[UIImage imageNamed:@"bc_bigTalk_unable"] forState:UIControlStateNormal];
    self.bigTalkBtn.frame = CGRectMake((SCREEN_WIDTH-151)*0.5, SCREEN_HEIGHT -94-151, 151, 151);
    [self.bigTalkBtn addTarget:self action:@selector(bigTalkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bigTalkBtn];
    self.bigTalkBtn.adjustsImageWhenHighlighted = NO;
    
    self.TalkShowTitle = [[UILabel alloc]init];
    self.TalkShowTitle.font = [UIFont systemFontOfSize:16.f];
    self.TalkShowTitle.text = @"远程通话";
    self.TalkShowTitle.textColor = COLOR_STRING(@"#2F2F2F");
    self.TalkShowTitle.textAlignment = NSTextAlignmentCenter;
    self.TalkShowTitle.frame = CGRectMake(0, CGRectGetMaxY(self.bigTalkBtn.frame),SCREEN_WIDTH, 18);
    [self.view addSubview:self.TalkShowTitle];
    
    self.TalkShowsubTitle = [[UILabel alloc]init];
    self.TalkShowsubTitle.font = [UIFont systemFontOfSize:16.f];
    self.TalkShowsubTitle.text = @"";
    self.TalkShowsubTitle.textColor = COLOR_STRING(@"#999999");
    self.TalkShowsubTitle.textAlignment = NSTextAlignmentCenter;
    self.TalkShowsubTitle.frame = CGRectMake(0, CGRectGetMaxY(self.TalkShowTitle.frame)+10,SCREEN_WIDTH, 18);
    [self.view addSubview:self.TalkShowsubTitle];
}

#pragma mark - 截图保存系统相册
- (void)savePhone:(UIImage*)image{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        BOOL granted = status == PHAuthorizationStatusAuthorized ? TRUE : FALSE;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                UIImageWriteToSavedPhotosAlbum([image copy], self,
                                               @selector(image:didFinishSavingWithError:contextInfo:), nil);
            } else {
                NSLog(@"Do not get the appropriate permissions, please open and try again.");
            }
        });
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        NSLog(@"Failed to save photo to camera roll.");
        if ([BKVideoPlayController shareInstance].playView.isFullView) {
            [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"截屏保存失败" and:[BKVideoPlayController shareInstance].playView];

        }else{
            
            [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"截屏保存失败" and:APP_DELEGATE.window];
        }

    }
    else
    {
        NSLog(@"The photo has been saved to the local phone");
        if ([BKVideoPlayController shareInstance].playView.isFullView) {
            [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"截屏保存成功" and:[BKVideoPlayController shareInstance].playView];
        }else{
            [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"截屏保存成功" and:APP_DELEGATE.window];
        }

    }
}

#pragma mark- BKCamera delegate
- (void)BkCameradidReceiveFrameInfoWithvideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount isHwDecode:(BOOL)isHwDecode{
    if (fps == 0 || videoBps == 0) {
        [[BKVideoPlayController shareInstance] changeTheUIActivityIndicatorViewState:YES];
    }else{
        [[BKVideoPlayController shareInstance] changeTheUIActivityIndicatorViewState:NO];
    }
//    NSString *str = [NSString stringWithFormat:@" fps=%ld,在线人数=%ld,\n 接收帧数=%lu,丢帧数=%lu,\n videbps=%ld,audioBps=%ld ",fps,onlineNm,frameCount,incompleteFrameCount,videoBps,audioBps];
//    NSLog(@"%@",str);
}

- (void)BKCameraDeviceWillStartShowVideo{
    //显示loading
    [[BKVideoPlayController shareInstance] changeTheUIActivityIndicatorViewState:YES];
    [[BKVideoPlayController shareInstance] changeTheVideoPlayStateWithIsLising:YES];
}

- (void)BKCameraDeviceDidStartShowVideo{
    //关闭loading
    [[BKVideoPlayController shareInstance] changeTheUIActivityIndicatorViewState:NO];
    if ([BKCameraManager shareInstance].isVideoShow) {
        if (![[BKVideoPlayController shareInstance].playView GetTheVolumBtnSelectState]) {
            [[BKCameraManager shareInstance] StartListenAudio];
        }
        [self changeThebigTalkBtnEnable:YES];
    }
}

- (void)BKCameraDeviceStateInfoWithIsTalk:(BOOL)isTalk{
    [[BKVideoPlayController shareInstance] changeTheVideoPlayStateWithIsTalk:isTalk];
    if (self.isCancelTalkContent) {
        [[BKCameraManager shareInstance] StopTalkToDevice];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bigTalkBtn.selected = NO;
            self.TalkShowTitle.text = @"远程通话";
            self.TalkShowsubTitle.text = @"";
        });
        
        self.isCancelTalkContent = NO;
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bigTalkBtn.selected = isTalk;
        if (isTalk) {
            self.TalkShowTitle.text = @"挂断";
            self.TalkShowsubTitle.text = @"正在跟设备通话";
        }else{
            self.TalkShowTitle.text = @"远程通话";
            self.TalkShowsubTitle.text = @"";
        }
        
    });
    //主动打电话给设备,才上报新增通话记录
    if(isTalk && self.AutomCallIndex != 1){
        //创建通话记录
        [XBKNetWorkManager requestAddNewCallRecordsWithSN:APP_DELEGATE.snData.sn AndiPhoneNumber:APP_DELEGATE.mLoginResult.userName AndAndFinish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        }];
    }
}

- (void)BKCameraDeviceStateInfoWithIsVideoShow:(BOOL)isVideoShow{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"videoShow=%d",isVideoShow);
        [[BKVideoPlayController shareInstance] changeTheVideoPlayStateWithIsShow:isVideoShow];
        if (isVideoShow == NO) {
            [self changeThebigTalkBtnEnable:isVideoShow];
        }
        [[BKVideoPlayController shareInstance].playView changeTheContentStateShowLabel:[self checkTheContentStateIsOnLine] andIsShow:!isVideoShow];
    });
}

/**机器连接状态改变回调*/
- (void)BKCameraDeviceStateInfoWithContentState:(DeviceContentStateType)contentState{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BKVideoPlayController shareInstance].playView changeTheContentStateShowLabel:[self checkTheContentStateIsOnLine] andIsShow:![BKCameraManager shareInstance].isVideoShow];
        
    });
}

- (void)bigTalkBtnClick:(UIButton*)btn{
    if (!self.isMaster) {//判断是否有通讯录身份,没有提示先添加身份.
        [self ShowTheTipNOFamily];
        return;
    }
    if (self.isEnableTalk) {
        btn.selected = !btn.selected;
        [self BKVideoViewTalk:btn.selected];
        if (btn.selected) {
            self.TalkShowTitle.text = @"正在连接中...";
            [self.bigTalkBtn setImage:[UIImage imageNamed:@"bc_bigTalk_enable"] forState:UIControlStateNormal];
            [self.bigTalkBtn setImage:[UIImage imageNamed:@"bc_bigTalk_select"] forState:UIControlStateSelected|UIControlStateHighlighted];
            self.isCancelTalkContent = NO;
        }else{
            if([BKVideoPlayController shareInstance].playView.isFullView){
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"取消通话" and:[BKVideoPlayController shareInstance].playView];
                
            }else{
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"取消通话" and:APP_DELEGATE.window];
            }

            if (![BKCameraManager shareInstance].isTalk) {
                self.isCancelTalkContent = YES;
            }
            self.TalkShowTitle.text = @"远程通话";
            [self.bigTalkBtn setImage:[UIImage imageNamed:@"bc_bigTalk_enable"] forState:UIControlStateNormal];
            [self.bigTalkBtn setImage:[UIImage imageNamed:@"bc_bigTalk_select"] forState:UIControlStateSelected|UIControlStateHighlighted];
        }
    }
    
    [[BKVideoPlayController shareInstance] changeTheVideoPlayStateWithIsTalk:btn.selected];
}

- (void)changeThebigTalkBtnEnable:(BOOL)enable{
    self.isEnableTalk = enable;
    if (enable) {

        [self.bigTalkBtn setImage:[UIImage imageNamed:@"bc_bigTalk_enable"] forState:UIControlStateNormal];
        [self.bigTalkBtn setImage:[UIImage imageNamed:@"bc_bigTalk_select"] forState:UIControlStateSelected];
        self.TalkShowTitle.text = @"远程通话";
        self.isCancelTalkContent = NO;

    }else{
        [self.bigTalkBtn setImage:[UIImage imageNamed:@"bc_bigTalk_unable"] forState:UIControlStateNormal];
        [self.bigTalkBtn setImage:[UIImage imageNamed:@"bc_bigTalk_unable"] forState:UIControlStateSelected];
        self.TalkShowTitle.text = @"远程通话";
        
        
    }
}
//检查设备是否在线
- (BOOL)checkTheContentStateIsOnLine{
    if ([BKCameraManager shareInstance].deviceState != DeviceContentStateType_onLine) {
        NSLog(@"device is offline");
        [[BKVideoPlayController shareInstance] changeTheVideoPlayStateWithIsShow:NO];
        [[BKVideoPlayController shareInstance] changeTheVideoPlayStateWithIsTalk:NO];
        
        [[BKVideoPlayController shareInstance].playView changeTheContentStateShowLabel:NO andIsShow:![BKCameraManager shareInstance].isVideoShow];

        return NO;
    }else{
        NSLog(@"device is online");
        [[BKVideoPlayController shareInstance].playView changeTheContentStateShowLabel:YES andIsShow:![BKCameraManager shareInstance].isVideoShow];

        return YES;
    }
    
}

- (void)BKCameraDeviceTalkError{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([BKVideoPlayController shareInstance].playView.isFullView){
            [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"通话失败,请稍后重试" and:[BKVideoPlayController shareInstance].playView];
        }else{
            [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"通话失败,请稍后重试" and:APP_DELEGATE.window];
        }
    });

}

- (void)BKCameraDevicedidSendIOCtrlResult:(BOOL)success channel:(NSInteger)channel type:(NSInteger)type{
}

- (void)BKCameraDevicedidStartShowResult:(BOOL)success channel:(NSInteger)channel{
    NSLog(@"Send-startShow-isSuccess:%d",success);
    if (!success) {//视频连接失败
        [[BKCameraManager shareInstance] StopShowVideo];
        [[BKVideoPlayController shareInstance].playView defaultSetShowView];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([BKVideoPlayController shareInstance].playView.isFullView){
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"视频连接失败,请稍后重试" and:[BKVideoPlayController shareInstance].playView];
            }else{
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"视频连接失败,请稍后重试" and:APP_DELEGATE.window];
            }
        });
    }
}
#pragma mark - videoplayCtr Delegate
- (void)BKVideoViewBackClick{
    
    self.isPopCtr = YES;
    if(self.isNeedPopMore){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        if([self findPreTheControllerWith:NSStringFromClass([BKBabyCareMainCtr class])] != -1){
            NSInteger index = [self findPreTheControllerWith:NSStringFromClass([BKBabyCareMainCtr class])];
            NSInteger Qindex = [self findPreTheControllerWith:NSStringFromClass([QRCodeViewController class])];
            //判断有配网页面,直接退到根控制器,否则就退到上一页.
            if (Qindex != -1) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popToViewController:self.navigationController.viewControllers[index-1] animated:YES];
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (NSInteger)findPreTheControllerWith:(NSString*)name{
    for (NSInteger i =0 ; i<self.navigationController.viewControllers.count; i++) {
        UIViewController *ctr = [self.navigationController.viewControllers objectAtIndex:i];
        NSString *str = NSStringFromClass([ctr class]);
        if ([str isEqualToString:name]) {
            return i;
        }
    }
    //    NSString *CnStr=[NSString stringWithUTF8String:object_getClassName(ctr)];
    return -1;
}

- (void)BKVideoViewMenuClick:(UIButton*)btn{
    if (self.popView == nil) {
        self.popView = [[BKBabyCareMenuPopView alloc]initWithPopLocation:CGPointMake(CGRectGetMidX(btn.frame), CGRectGetMaxY(btn.frame))];
        self.popView.delegate = self;
    }

    [self.view addSubview:self.popView];
    [self.popView startAnimation];
}

//显示viewframe改变,同步更改显示图层
- (void)BKVideoViewHasChanged{
    [[BKCameraManager shareInstance] reloadTheShowLayer];
}
//截图
- (void)BKVideoViewSnapClick{
    
    UIImage * image = [[BKCameraManager shareInstance] SnapShotImage];
    if (image) {
        [self savePhone:image];
    }
}
//播放
- (void)BKVideoViewPlay:(BOOL)isPlay{
    //关闭其他音频播放
    [self closeOtherAudio];
    if (isPlay) {
        if (![self checkTheContentStateIsOnLine]) {
            if([BKVideoPlayController shareInstance].playView.isFullView){
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"设备未在线" and:[BKVideoPlayController shareInstance].playView];
            }else{
                [self ShowTheTipGoConfigNet];
            }

            [[BKCameraManager shareInstance] ConnectDevice];

            return ;
        }
        if ([BKVideoPlayController shareInstance].myNetworkState == BKNewWorkState_WWAN) {
            [[BKVideoPlayController shareInstance] networkHasChange];
            
        }else{
            
            [[BKCameraManager shareInstance] StartShowVideoWithView:[BKVideoPlayController shareInstance].playView.showView];
        }
        
        [[BKVideoPlayController shareInstance].playView changeTheContentStateShowLabel:[self checkTheContentStateIsOnLine] andIsShow:NO];
        
    }else{
        [[BKCameraManager shareInstance] StopShowVideo];
        
    }
}
//监听静音
- (void)BKVideoViewVolume:(BOOL)isClose{
    if (isClose) {
        [[BKCameraManager shareInstance] StartListenAudio];
    }else{
        [[BKCameraManager shareInstance] StopListenAudio];
    }
}
//通话
- (void)BKVideoViewTalk:(BOOL)isTalk{
    if (![self checkTheContentStateIsOnLine]) {
        [[BKCameraManager shareInstance] ConnectDevice];
        return ;
    }
    if (isTalk) {
        [[BKCameraManager shareInstance] StartTalkToDevice];
    }else{
        [[BKCameraManager shareInstance] StopTalkToDevice];
    }
}
//流量继续播放
- (void)BKVideoNetHasChangeWWANGoPlay{
    [[BKCameraManager shareInstance] StartShowVideoWithView:[BKVideoPlayController shareInstance].playView.showView];
}
//流量停止播放
- (void)BKVideoNetHasChangeWWANStopPlay{
    if ([BKCameraManager shareInstance].isVideoShow) {
        [[BKCameraManager shareInstance] StopShowVideo];
        [[BKVideoPlayController shareInstance] changeTheVideoPlayStateWithIsShow:NO];
    }
}

#pragma mark - BKBabyCareMenuPopViewDelegate 菜单功能跳转
- (void)BCMenuPopBtnClick:(NSInteger)index{
    if(index == 0){
        if (APP_DELEGATE.snData.sn.length && [self checkTheContentStateIsOnLine]) {
            //通讯录管理
            BKConfigAddressBookCtr *ctr = [[BKConfigAddressBookCtr alloc]init];
            [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
        }else{
            [[BKCameraManager shareInstance] ConnectDevice];
            [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"设备不在线" and:self.view];
        }
        
    }else if (index == 1){//通话记录
        BKCallRecordViewController *ctr = [[BKCallRecordViewController alloc]init];
        [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];

    }else if (index == 2){//设备管理
        if (APP_DELEGATE.mLoginResult.SN.length && APP_DELEGATE.mLoginResult.SN != nil) {
            BKDeviceManagnerCtr *ctr = [[BKDeviceManagnerCtr alloc]init];
            [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
        }
    }
}
#pragma mark - 弹窗提示
//添加身份提示
- (void)ShowTheTipNOFamily{
    BKCommonShowTipCtr *ctr = [[BKCommonShowTipCtr alloc]init];
    [ctr showWithTitle:@"提示" andsubTitle:@"为了宝贝的安全，请先设置\n通讯录身份，才可以呼叫宝贝" andLeftBtntitel:@"去通讯录" andRightBtnTitle:@"" andIsTap:YES AndLeftBtnAction:^{
        NSLog(@"去通讯录");
        [self BCMenuPopBtnClick:0];
    } AndRightBtnAction:^{
        
    }];
    [ctr startShowTipWithController:self];
}
//离线提示
- (void)ShowTheTipGoConfigNet{
    BKCommonShowTipCtr *ctr = [[BKCommonShowTipCtr alloc]init];
    [ctr showWithTitle:@"提示" andsubTitle:@"当前设备未联网,请先配置网络" andLeftBtntitel:@"取消" andRightBtnTitle:@"去联网" andIsTap:NO AndLeftBtnAction:^{
        
    } AndRightBtnAction:^{
        [self BCMenuPopBtnClick:2];
    }];
    [ctr startShowTipWithController:self];
}


@end
