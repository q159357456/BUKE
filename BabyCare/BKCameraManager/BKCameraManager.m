//
//  BKCameraManager.m
//  babycaretest
//
//  Created by Don on 2019/4/18.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCameraManager.h"
#import <IOTCamera/IOTCamera.h>
#import <IOTCamera/AVIOCTRLDEFs.h>
#import <IOTCamera/AVFrameInfo.h>
#import "BKVideoPlayController.h"

#define MaxTryCount 5 //最大重连次数

@interface BKCameraManager()<CameraDelegate>

@property (nonatomic, strong) Camera *myCamera;
@property (nonatomic, assign) NSInteger channel;

@property (nonatomic, strong) CIContext *videoContext;
@property (nonatomic, assign) BOOL isGetFirstFrame; //是否获取到第一帧

@property (nonatomic, strong) UIImageView *showView;

@property (nonatomic, assign) NSInteger tryTalkCount;
@property (nonatomic, assign) NSInteger tryListenCount;
@property (nonatomic, assign) NSInteger tryP2PConnetCount;

@property (nonatomic, assign) CMSampleBufferRef lastBuffer;//最后一帧图像
@property (nonatomic, assign) BOOL isSendBeiJiao;//是否是被叫发送通话

@end

@implementation BKCameraManager

+(instancetype)shareInstance{
        static dispatch_once_t onceToken;
        static BKCameraManager *manager =nil;
        dispatch_once(&onceToken, ^{
            manager = [[BKCameraManager alloc]init];
            
        });
        return manager;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PUSHMUSIC-BabyCare" object:nil];
}
- (Camera *)myCamera{
    if (_myCamera == nil) {
        _myCamera = [[Camera alloc] TK_initWithName:@"XBK1"];
        _myCamera.delegate = self;
        _myCamera.isUsingGaAudioUnit = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPushNotic:) name:@"PUSHMUSIC-BabyCare" object:nil];
    }
    return _myCamera;
}

-(void)CameraInitializeWithUID:(NSString*)uid Pwd:(NSString*)pwd Account:(NSString*)account Channel:(NSInteger)channel
{
    self.myCamera.uid = uid;
    self.myCamera.viewAcc = account;
    self.myCamera.viewPwd = pwd;
    self.myCamera.isUsingGaAudioUnit = YES;
    self.myCamera.mfGaPCMAmplifier_Gain_AfterMIC = 2.0;
    self.myCamera.mfGaPCMAmplifier_Gain_BeforeSpeak = 1.0;
    self.channel = channel;
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0f) {
        self.isHardDecode = YES;
    } else {
        self.isHardDecode = NO;
    }
}

#pragma mark - 功能方法
-(void)ConnectDevice{
    [self DisconnectDevice];
    if (!APP_DELEGATE.snData.uid.length) return;
    
    [[BKCameraManager shareInstance] CameraInitializeWithUID:APP_DELEGATE.snData.uid Pwd:@"888888" Account:@"User" Channel:0];
    //开始连接设备
    [self.myCamera connect:self.myCamera.uid];
    //开启AV通道
    [self.myCamera start:self.channel viewAccount:self.myCamera.viewAcc viewPassword:self.myCamera.viewPwd is_playback:NO];
}

/**断开设备连接*/
-(void)DisconnectDevice{
    [self.myCamera stop:self.channel];
    [self.myCamera disconnect];
}

/**开启视频监控*/
-(void)StartShowVideoWithView:(UIImageView*)showView{

    if (self.deviceState != DeviceContentStateType_onLine) {
        [self ConnectDevice];
        return;
    }
    if (self.isVideoShow) {
        return;
    }
    self.showView = showView;
    self.sampleBufferDisplayLayer.frame = showView.bounds;
    self.sampleBufferDisplayLayer.position = CGPointMake(CGRectGetMidX(showView.bounds), CGRectGetMidY(showView.bounds));
    [showView.layer addSublayer:self.sampleBufferDisplayLayer];

    self.myCamera.isShowInLiveView = YES;
    [self.myCamera setHWDecodingAbility:(UInt32)self.channel requestHWDecode:self.isHardDecode];
    [self.myCamera startShow:self.channel ScreenObject:self];
    
    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BKCameraDeviceWillStartShowVideo)]) {
        [self.managerDelegate BKCameraDeviceWillStartShowVideo];
    }
}

/**关闭视频监控*/
-(void)StopShowVideo{
    NSLog(@"关闭视频");
    //先同步关闭监听通话
    if (self.isListen) {
        [self StopListenAudio];
    }
    if(self.isTalk){
        [self StopTalkToDevice];
    }
    
    [self.myCamera stopShow:self.channel];
    
    [self changeVideoShowState:NO];
    
    if (self.isHardDecode) {
        [self.sampleBufferDisplayLayer removeFromSuperlayer];
        //停止后显示最后一帧视频
        self.showView.image =[self GetImageFromBuffer:self.lastBuffer];
    }
}

/**开启监听*/
-(void)StartListenAudio{
    if (self.deviceState != DeviceContentStateType_onLine) {
        [self ConnectDevice];
        return;
    }
    if (self.isListen || !self.isVideoShow) {
        return;
    }
    if (!self.isTalk) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }
    
    self.myCamera.isListening = YES;
    [self.myCamera startSoundToPhone:self.channel];
}

/**关闭监听*/
-(void)StopListenAudio{
    
    self.myCamera.isListening = NO;
    [self.myCamera stopSoundToPhone:self.channel];
    [self changeListenState:NO];
    self.isReadyTalk = NO;
}

/**开启通话*/
-(void)StartTalkToDevice{
    if (self.deviceState != DeviceContentStateType_onLine) {
        [self ConnectDevice];
        return;
    }
    if (self.isTalk) return;
    self.talkStepflag = 0;
    //检查麦克风权限,开启对讲
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                self.isReadyTalk = NO;
                //检查设备是否忙碌
                [self checkDeviceIsTalkBusy];
            } else {
                NSLog(@"没有开启麦克风权限,请重试");
            }
        });
    }];
}

- (void)AnswerTalkToDevice{
    //检查麦克风权限,开启对讲
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [self ringAfterContentTalk];
            } else {
                NSLog(@"没有开启麦克风权限,请重试");
            }
        });
    }];
}

- (void)ringTheDeviceTalk{
    if (self.deviceState != DeviceContentStateType_onLine) {
        [self ConnectDevice];
        return;
    }
    //推送设备响铃命令
    [self deviceStartRinging];
}

- (void)ringAfterContentTalk{
    if (self.deviceState != DeviceContentStateType_onLine) {
        [self ConnectDevice];
        return;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
//    self.myCamera.mfGaPCMAmplifier_Gain_AfterMIC = 2.0;
//    self.myCamera.mfGaPCMAmplifier_Gain_BeforeSpeak = 1.0;
    self.talkStepflag = 3;
    [self.myCamera startSoundToDevice:self.channel];
}

- (void)ringAfterContentTalkdelay{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    //    self.myCamera.mfGaPCMAmplifier_Gain_AfterMIC = 2.0;
    //    self.myCamera.mfGaPCMAmplifier_Gain_BeforeSpeak = 1.0;
    NSLog(@"发送startSoundToDevice");
    [self.myCamera startSoundToDevice:self.channel];
}

/**关闭通话*/
-(void)StopTalkToDevice{
    if (!self.isTalk) {
        return;
    }
//    self.talkStepflag = 0;
    NSLog(@"关闭通话");
    [self.myCamera stopSoundToDevice:self.channel];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    [self changeTalkState:NO];
    self.isReadyTalk = NO;
}

//截屏
-(UIImage*)SnapShotImage{
    if(self.isVideoShow){
        
        if (self.deviceState != DeviceContentStateType_onLine) {
            NSLog(@"snap image is null");
            return nil;
        }
        return [self.myCamera TK_getSnapShotImageWithChannel:self.channel];
    }else{
        return nil;
    }
}

/**刷新显示图层frame*/
- (void)reloadTheShowLayer{
    [BKCameraManager  shareInstance].sampleBufferDisplayLayer.frame = _showView.bounds;
    [BKCameraManager  shareInstance].sampleBufferDisplayLayer.position =CGPointMake(CGRectGetMidX(_showView.bounds), CGRectGetMidY(_showView.bounds));
    [[BKCameraManager shareInstance].sampleBufferDisplayLayer flushAndRemoveImage];
}

-(void)changeTheVolumeIsOpen:(BOOL)isOpen{
    self.myCamera.isListening = isOpen;
}

#pragma mark - privteMeth
- (void)changeListenState:(BOOL)isOpen{
    self.isListen = isOpen;
    //状态改变回调
    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BKCameraDeviceStateInfoWithIsListen:)]) {
        [self.managerDelegate BKCameraDeviceStateInfoWithIsListen:self.isListen];
    }

}
- (void)changeTalkState:(BOOL)isTalk{
    self.isTalk = isTalk;
    //状态改变回调
    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BKCameraDeviceStateInfoWithIsTalk:)]) {
        [self.managerDelegate BKCameraDeviceStateInfoWithIsTalk:self.isTalk];
    }

}
- (void)changeVideoShowState:(BOOL)isShow{
    
    self.isVideoShow = isShow;
    //状态改变回调
    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BKCameraDeviceStateInfoWithIsVideoShow:)]) {
        [self.managerDelegate BKCameraDeviceStateInfoWithIsVideoShow:self.isVideoShow];
    }

    if (!isShow) {
        self.isGetFirstFrame = NO;
        self.isStartShow = NO;
    }
}

#pragma mark - Layer Show 解码渲染图像
//上抛硬解码图像
- (void)CameraUpdateDecodedH264SampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    if (!self.isGetFirstFrame) {
        self.isGetFirstFrame = YES;
        [self commandGetAudioOutFormatWithChannel:self.channel];
    }
    if (sampleBuffer){
        [self transformToImage:sampleBuffer];
    }
}
//上抛软解码图像
- (void)updateToScreen2:(NSArray*)arrs
{
    if (!self.isGetFirstFrame) {
        self.isGetFirstFrame = YES;
        [self commandGetAudioOutFormatWithChannel:self.channel];

    }
    if (!self.videoContext) self.videoContext = [CIContext contextWithOptions:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @autoreleasepool
        {
            CIImage *ciImage = [arrs objectAtIndex:0];
            CGImageRef cgimg = [self.videoContext createCGImage:ciImage fromRect:[ciImage extent]];
            UIImage *img = [UIImage imageWithCGImage:cgimg];
            CGImageRelease(cgimg);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.showView.image = img;
            });
        }
    });
}

- (AVSampleBufferDisplayLayer *)sampleBufferDisplayLayer{
    if (_sampleBufferDisplayLayer == nil) {
        _sampleBufferDisplayLayer = [[AVSampleBufferDisplayLayer alloc] init];
        _sampleBufferDisplayLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _sampleBufferDisplayLayer.opaque = YES;
    }
    return _sampleBufferDisplayLayer;
}

- (void)transformToImage:(CMSampleBufferRef)sampleBuffer
{

    if (sampleBuffer){
        //复制最后一帧数据保存
        CMSampleBufferCreateCopy(kCFAllocatorDefault, sampleBuffer, &_lastBuffer);

        CFRetain(sampleBuffer);
        [self.sampleBufferDisplayLayer enqueueSampleBuffer:sampleBuffer];
        CFRelease(sampleBuffer);
        if (self.sampleBufferDisplayLayer.status == AVQueuedSampleBufferRenderingStatusFailed){
            NSLog(@"ERROR: %@", self.sampleBufferDisplayLayer.error);

            if (-11847 == self.sampleBufferDisplayLayer.error.code){
                [self.sampleBufferDisplayLayer flushAndRemoveImage];
            }
        }
        
    }else{
        NSLog(@"ignore null samplebuffer");
    }
}

- (UIImage* )GetImageFromBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaNoneSkipFirst|kCGBitmapByteOrder32Little, provider, NULL, true, kCGRenderingIntentDefault);
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];

    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return image;
}
#pragma mark - 回调方法
#pragma mark -CameraDelegate
/**
 Session连线状态回调
 @param camera camera对象
 @param status 连线状态
 */
- (void)camera:(Camera *)camera didChangeSessionStatus:(NSInteger)status{
    if (camera != self.myCamera){
        return;
    }
    NSLog(@"_didChangeSessionStatus:%ld", (long)status);
    [self verifyConnectionStatus];
}

/**
 指定通道的连线状态回调

 @param camera camera对象
 @param channel av通道
 @param status 连线状态
 */
- (void)camera:(Camera *)camera didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status{
    NSLog(@"_didChangeChannelStatus:%ld", (long)status);
    if (camera != self.myCamera){
        return;
    }
    [self verifyConnectionStatus];
}

/**channel && Session change*/
- (void)verifyConnectionStatus{
    NSInteger status = self.myCamera.sessionState;
    NSInteger channelstatus = [self getTheChanelStateWithChanel];
    
    if (status == CONNECTION_STATE_CONNECTING) {
        NSLog(@"Connecting-连接中");
        self.deviceState = DeviceContentStateType_Connecting;
    }
    else if (status == CONNECTION_STATE_CONNECTED && channelstatus == CONNECTION_STATE_CONNECTED) {
        NSLog(@"Online");
        self.deviceState = DeviceContentStateType_onLine;
        
        if (self.isInManagerView) {
            //重连在线后,自动重连监控,监听
            if (self.isVideoShow) {
                [self StopShowVideo];
                [self StartShowVideoWithView:self.showView];
            }
            if (self.isListen) {
                [self StopListenAudio];
                [self StartListenAudio];
            }
        }
        
        [self postGetTheDeviceInfoCMD];
        
    } else if (status == CONNECTION_STATE_WRONG_PASSWORD) {
        NSLog(@"Wrong password");
        self.deviceState = DeviceContentStateType_offLine;
        NSLog(@"Offline- status:%ld",(long)status);
    } else if (status == CONNECTION_STATE_DISCONNECTED ||
               status == CONNECTION_STATE_UNKNOWN_DEVICE ||
               status == CONNECTION_STATE_TIMEOUT ||
               status == CONNECTION_STATE_CONNECT_FAILED) {
        NSLog(@"Offline- status:%ld",(long)status);
        self.deviceState = DeviceContentStateType_offLine;
        //掉线后,如果正在通话,就切断通话.
        if(self.isTalk){
            [self StopTalkToDevice];
        }
    }else{
        NSLog(@"Offline- status:%ld",(long)status);
        self.deviceState = DeviceContentStateType_offLine;
    }
    
    //状态改变回调
    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BKCameraDeviceStateInfoWithContentState:)]) {
        [self.managerDelegate BKCameraDeviceStateInfoWithContentState:self.deviceState];
    }
    APP_DELEGATE.isOnLine = [BKCameraManager shareInstance].deviceState == DeviceContentStateType_onLine ? YES:NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IOTYPE_BATTERY_LEVEL_RESP" object:@(APP_DELEGATE.ElectricQuantity)];

}

/**
 连线失败错误码的回调
 @param camera camera对象
 @param connFailErrCode 连线失败的错误码
 */
- (void)camera:(Camera *)camera didconnFailErrCode:(NSInteger)connFailErrCode{
    if (connFailErrCode != 0) {
        NSLog(@"error = %ld",connFailErrCode);
//        -22 8
        [self DisconnectDevice];
//        自动重连
        if (self.tryP2PConnetCount < MaxTryCount) {
            [self ConnectDevice];
            self.tryP2PConnetCount += 1;
            NSLog(@"正在第%ld次-重新连接- ",self.tryP2PConnetCount);
        }
        
    }else{
        self.tryP2PConnetCount = 0;
    }
}
/**
 监听通道建立成功的回调
 @param camera camera对象
 @param isSuccess 是否建立成功
 @param channel av通道
 */
- (void)camera:(Camera *)camera didStartListenSuccess:(BOOL)isSuccess Channel:(NSInteger)channel{
    
    [self changeListenState:isSuccess];
    NSLog(@"listen issuccess = %d",isSuccess);
    self.myCamera.isListening = isSuccess;
    
    if (!isSuccess && self.tryListenCount<=MaxTryCount) {
        //重连拨号
        if (self.isVideoShow) {
            NSLog(@"监听失败,开始重拨");
            [self StartListenAudio];
            self.tryListenCount += 1;
            NSLog(@"监听失败,开始重拨-第%ld次",(long)self.tryListenCount);
        }
        
    }else{
        self.tryListenCount = 0;

    }
}
/**
 对讲通道建立成功的回调
 @param camera camera对象
 @param isSuccess 是否建立成功
 @param errorCode 错误码
 */
- (void)camera:(Camera *)camera didStartTalkSuccess:(BOOL)isSuccess ErrorCode:(NSInteger) errorCode{
    NSLog(@"拨号 talk issuccess = %d,errorCode = %ld,talkstepflag=%ld",isSuccess,errorCode,self.talkStepflag);
    if (self.talkStepflag == 3) {
        if (!_isTalk) {
            [self changeTalkState:isSuccess];
            if(!isSuccess){
                if(self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BKCameraDeviceTalkError)]){
                    [self.managerDelegate BKCameraDeviceTalkError];
                }
            }
        }
        
    }else{
        NSLog(@"非3无效通话指令");
        if(isSuccess && !_isTalk){
            _isTalk = YES;
            [self StopTalkToDevice];
            if(self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BKCameraDeviceTalkError)]){
                [self.managerDelegate BKCameraDeviceTalkError];
            }
        }
    }
}

/**
 指定通道指令接收回调
 @param camera camera对象
 @param type 指令类型
 @param data 指令数据
 @param size 指令数据长度
 @param channel av通道
 */
- (void)camera:(Camera *)camera didReceiveIOCtrlWithType:(NSInteger)type Data:(const char*)data DataSize:(NSInteger)size Channel:(NSInteger)channel{
    
    NSString*datastr =[NSString stringWithUTF8String:data];
    NSLog(@"type=%ld, data:%@,size =%ld",type,datastr,size);

    if (type == IOTYPE_REMOTE_MUSIC_RESP) { //点播回调
        if(1 == [datastr integerValue]){
            NSLog(@"该歌曲正在播放,点播 issuccess = %@",datastr);
        }else if (0 == [datastr integerValue]){
            NSLog(@"点播成功 issuccess = %@",datastr);
        }
    }else if (type == IOTYPE_STOP_MUSIC_PLAY_RESP){//停止播放回调
        NSLog(@"停止播放(%@)成功",datastr);
    }else if (type == IOTYPE_CALL_RESPON_RESP){//通话指令回调
        if (40 == [datastr integerValue]) { //设备不在通话
            NSLog(@"设备不在通话");
            if(self.talkStepflag == 1){
                self.isReadyTalk = YES;
                [self ringTheDeviceTalk];
            }else{
                NSLog(@"非1无效通话指令");
            }
        }else if (41 == [datastr integerValue]){//设备正在通话

            NSLog(@"设备正在通话中,请稍后再拨!!");
            if ([BKVideoPlayController shareInstance].playView.isFullView) {
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"设备正在通话中,请稍后再拨!" and:[BKVideoPlayController shareInstance].playView];
            }else{
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"设备正在通话中,请稍后再拨!" and:APP_DELEGATE.window];
            }
            [self changeTalkState:NO];
            self.isReadyTalk = NO;
            
            self.talkStepflag = 0;
            
        }else if (50 == [datastr integerValue]){//主动打电话,响铃回调

            if (self.talkStepflag == 2) {
                self.talkStepflag = 3;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self ringAfterContentTalkdelay];
                });
            }else{
                NSLog(@"非2无效通话指令");
            }
            
        }else if (51 == [datastr integerValue]){
            self.talkStepflag = 0;
            [self changeTalkState:NO];
            if(self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BKCameraDeviceTalkError)]){
                [self.managerDelegate BKCameraDeviceTalkError];
            }

        }else if (10 == [datastr integerValue] || 20 == [datastr integerValue] || 11 == [datastr integerValue] || 21 == [datastr integerValue]){
            NSLog(@"接通挂断命令");
        }
        else{
            
            if (!self.isSendBeiJiao) {
                self.talkStepflag = 0;
                [self changeTalkState:NO];
                if(self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BKCameraDeviceTalkError)]){
                    [self.managerDelegate BKCameraDeviceTalkError];
                }
            }

        }
        
        self.isSendBeiJiao = NO;
    }
    else if (type == IOTYPE_BATTERY_LEVEL_RESP){//获取设备电量，音量播放状态等信息回调
        NSArray *infoArray = [datastr componentsSeparatedByString:@","];
        NSLog(@"TF插卡:%@ ,电池电量:%@,是否播放音乐:%@,设备音量:%@",infoArray[0],infoArray[1],infoArray[3],infoArray[4]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IOTYPE_BATTERY_LEVEL_RESP" object:infoArray[1]];
    }else if (type == IOTYPE_DEVICE_UNBLIND_RESP){//设备解绑回调
        
    }else if (type == IOTYPE_CONTROL_VOL_RESP){//设备音量控制及播放控制设置回调
        
    }else if (type == 811){
        
    }else if (type == IOTYPE_MODIFY_FAMILY_RESP){
        NSLog(@"通讯录更新命令发送成功回调- %@",datastr);
    }
}

/**
 指定通道的视频宽高/fps/bps/在线人数/帧数/丢帧数等调试信息回调
 */
- (void)camera:(Camera *)camera didReceiveFrameInfoWithChannel:(NSInteger)channel videoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount isHwDecode:(BOOL)isHwDecode{
    if (videoBps >0 && fps >0  && !self.isStartShow) {
        NSLog(@"video is start");
        [self changeVideoShowState:YES];

        if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BKCameraDeviceDidStartShowVideo)]) {
            [self.managerDelegate BKCameraDeviceDidStartShowVideo];
        }
        self.isStartShow = YES;
    }
    

    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BkCameradidReceiveFrameInfoWithvideoWidth:VideoHeight:VideoFPS:VideoBPS:AudioBPS:OnlineNm:FrameCount:IncompleteFrameCount:isHwDecode:)]) {
        [self.managerDelegate BkCameradidReceiveFrameInfoWithvideoWidth:videoWidth VideoHeight:videoHeight VideoFPS:fps VideoBPS:videoBps AudioBPS:audioBps OnlineNm:onlineNm FrameCount:frameCount IncompleteFrameCount:incompleteFrameCount isHwDecode:isHwDecode];
    }
}

//camera,视频开启命令成功回调
- (void)camera:(Camera *)camera didStartShowResult:(BOOL)success channel:(NSInteger)channel
{
    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BKCameraDevicedidStartShowResult:channel:)]) {
        [self.managerDelegate BKCameraDevicedidStartShowResult:success channel:channel];
    }
}
//camera,CMD指令发送成功回调
- (void)camera:(Camera *)camera didSendIOCtrlResult:(BOOL)success channel:(NSInteger)channel type:(NSInteger)type
{
    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(BKCameraDevicedidSendIOCtrlResult:channel:type:)]) {
        [self.managerDelegate BKCameraDevicedidSendIOCtrlResult:success channel:channel type:type];
    }
    NSLog(@"CMD_isSuccess:%ld_type=%ld",success,(long)type);

}

#pragma mark - 通话功能指令
/**检查设备通话是否占线*/
-(void)checkDeviceIsTalkBusy{
    self.talkStepflag = 1;
    [self XBKCMDPushRequestWithType:IOTYPE_CALL_RESPON_REQ andParameter:@"4"];
    self.isSendBeiJiao = NO;
}
/**设备来电响铃*/ //3.5S后发送对讲的命令,进行通话
- (void)deviceStartRinging{
    self.talkStepflag = 2;
    [self XBKCMDPushRequestWithType:IOTYPE_CALL_RESPON_REQ andParameter:@"5"];
    self.isSendBeiJiao = NO;
}
/**接听设备来电*/
- (void)answerTheDeviceTalk{
    self.isSendBeiJiao = YES;
    [self XBKCMDPushRequestWithType:IOTYPE_CALL_RESPON_REQ andParameter:@"1"];
}
/**拒绝设备来电*/
- (void)refuseTheDeviceTalk{
    self.isSendBeiJiao = YES;
    [self XBKCMDPushRequestWithType:IOTYPE_CALL_RESPON_REQ andParameter:@"2"];
}
#pragma mark - 歌曲推送指令
/**推送单首歌曲到设备播放*/
- (void)pushMP3ToDeviceWithUrl:(NSString*)url{
    if(self.deviceState != DeviceContentStateType_onLine){
        [MBProgressHUD showError:@"设备未在线"];
        [self ConnectDevice];
        return;
    }
    NSString *arrrayString = [url stringByAppendingString:@"\n"];
    if ([arrrayString hasPrefix:@"https"]) {
        arrrayString = [arrrayString stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    }
    int total = 1;
    int packetLen = (int)arrrayString.length;
    int endflag = 1;
    int packetIndex = 0;
    @autoreleasepool {
        SMsgAVIoctrlListMp3Req *s = (SMsgAVIoctrlListMp3Req *)malloc(sizeof(SMsgAVIoctrlListMp3Req));
        s->packetLen =packetLen;
        s->total =total;
        s->endflag =endflag;
        s->packetIndex =packetIndex;
        memcpy(s->mp3ListPacket, [arrrayString UTF8String], [arrrayString length]);
        [self.myCamera sendIOCtrlToChannel:self.channel
                                      Type:IOTYPE_REMOTE_MUSIC_REQ
                                      Data:(char*)s
                                  DataSize:sizeof(SMsgAVIoctrlListMp3Req)];
    }
    
    [MBProgressHUD showSuccess:@"推送成功"];

}
/**推送多首歌曲到设备播放*/
- (void)pushMP3SToDeviceWithUrls:(NSArray*)urls{
    if(self.deviceState != DeviceContentStateType_onLine){
        [MBProgressHUD showError:@"设备未在线"];
        [self ConnectDevice];
        return;
    }

    NSInteger count = urls.count;
    NSMutableArray *newArray = [NSMutableArray array];
    NSInteger dataLong = 0;
    NSMutableArray *secondArray = [NSMutableArray array];
    //分包批量发送,一个包最大1024字节,url长度最大1000
    for (int i = 0;i<count; i++) {
        NSString *str = urls[i];
        if ([str hasPrefix:@"https"]) {
            str = [str stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
        }
        if ((dataLong + str.length) < 1000) {
            [secondArray addObject:str];
            dataLong += str.length;
        }else{
            dataLong = str.length;
            [newArray addObject:[secondArray copy]];
            [secondArray removeAllObjects];
            [secondArray addObject:str];

        }
        
        if (i == count-1 && secondArray.count) {
            [newArray addObject:[secondArray copy]];
            [secondArray removeAllObjects];
            [secondArray addObject:str];
        }
    }
    NSLog(@"分包个数%lu",(unsigned long)newArray.count);
    int total = (int)count;
    for (int i = 0; i<newArray.count; i++) {
        @autoreleasepool {
            
            NSString *arrrayString = [newArray[i] componentsJoinedByString:@"\n"];
            arrrayString = [arrrayString stringByAppendingString:@"\n"];

            int packetLen = (int)arrrayString.length;
            int endflag = i == newArray.count-1 ? 1:0;
            int packetIndex = i;
            SMsgAVIoctrlListMp3Req *s = (SMsgAVIoctrlListMp3Req *)malloc(sizeof(SMsgAVIoctrlListMp3Req));
            s->packetLen =packetLen;
            s->total =total;
            s->endflag =endflag;
            s->packetIndex =packetIndex;
            memcpy(s->mp3ListPacket, [arrrayString UTF8String], [arrrayString length]);
            [self.myCamera sendIOCtrlToChannel:self.channel
                                          Type:IOTYPE_REMOTE_MUSIC_REQ
                                          Data:(char*)s
                                      DataSize:sizeof(SMsgAVIoctrlListMp3Req)];
        }
    }
    [MBProgressHUD showSuccess:@"推送成功"];

}

/**停止播放*/
- (void)stopDevicePlayMP3{
    [self XBKCMDPushRequestWithType:IOTYPE_STOP_MUSIC_PLAY_REQ andParameter:@"stopMusic"];
}

#pragma mark - 设备相关指令
/**获取设备基础信息(音量,电量等)*/
- (void)postGetTheDeviceInfoCMD{
    [self XBKCMDPushRequestWithType:IOTYPE_BATTERY_LEVEL_REQ andParameter:@"deviceinfo"];
}
/**获取设备音量*/
- (void)postGetTheDeviceVolumeCMD{
    [self XBKCMDPushRequestWithType:IOTYPE_CONTROL_VOL_REQ andParameter:@"get_vol:"];
}
/**设置设备音量 0-100*/
- (void)postSetTheDeviceVolumeCMDWith:(NSInteger)vol{
    [self XBKCMDPushRequestWithType:IOTYPE_CONTROL_VOL_REQ andParameter:[NSString stringWithFormat:@"set_vol:%ld",vol]];
}
//设备播放控制指令
- (void)postDeviceNextPlayMusicCMD{
    [self XBKCMDPushRequestWithType:IOTYPE_CONTROL_VOL_REQ andParameter:@"next_music:"];
}
- (void)postDevicePreviousPlayMusicCMD{
    [self XBKCMDPushRequestWithType:IOTYPE_CONTROL_VOL_REQ andParameter:@"previous_music:"];
}
- (void)postDevicePlayMusicCMD{
    [self XBKCMDPushRequestWithType:IOTYPE_CONTROL_VOL_REQ andParameter:@"start_music:"];
}
- (void)postDeviceStopPlayMusicCMD{
    [self XBKCMDPushRequestWithType:IOTYPE_CONTROL_VOL_REQ andParameter:@"stop_music:"];
}

/**发送设备更新通讯录信息指令*/
- (void)postTheDeviceFamilyListUpdate{
    if(self.deviceState != DeviceContentStateType_onLine){
        [self ConnectDevice];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self XBKCMDPushRequestWithType:IOTYPE_MODIFY_FAMILY_REQ andParameter:@"updateFamily"];
        });
    }else{
        [self XBKCMDPushRequestWithType:IOTYPE_MODIFY_FAMILY_REQ andParameter:@"updateFamily"];
    }
}
#pragma mark - CMD 指令
/**接收视频第一帧后发送的指令(必须)*/
- (void)commandGetAudioOutFormatWithChannel:(NSInteger)channel
{
    SMsgAVIoctrlGetAudioOutFormatReq *s = (SMsgAVIoctrlGetAudioOutFormatReq *)malloc(sizeof(SMsgAVIoctrlGetAudioOutFormatReq));
    s->channel = (int)channel;
    [self.myCamera sendIOCtrlToChannel:channel
                                  Type:IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_REQ
                                  Data:(char *)s
                              DataSize:sizeof(SMsgAVIoctrlGetAudioOutFormatReq)];
    free(s);
}

/**CMD指令推送 指令类型:type ,参数Parameter:str */
- (void)XBKCMDPushRequestWithType:(CMDType)Type andParameter:(NSString*)str{
    if (self.myCamera.sessionState != CONNECTION_STATE_CONNECTED) {
        [self ConnectDevice];
        NSLog(@"CMD push error, device isOffline");
        return;
    }
    @autoreleasepool {
        char s[str.length];
        memcpy(s, [str UTF8String], [str length]);
        [self.myCamera sendIOCtrlToChannel:self.channel
                                      Type:Type
                                      Data:s
                                  DataSize:sizeof(s)];
    }
}

#pragma mark - 接收歌曲推送通知
//接收歌曲推送通知
-(void)musicPushNotic:(NSNotification*)notic{
    NSLog(@"%@",notic);
    NSArray *array = notic.object;
    if (!array.count) {
        [MBProgressHUD showError:@"推送失败:播放地址为空"];
        return;
    }
    if (array.count >1) {
        [[BKCameraManager shareInstance] pushMP3SToDeviceWithUrls:array];
    }else{
        [[BKCameraManager shareInstance] pushMP3ToDeviceWithUrl:array.firstObject];
    }
}
#pragma mark - chanel 连线状态
/**获取chanel 连线状态*/
- (NSInteger)getTheChanelStateWithChanel{
    return [self.myCamera getConnectionStateOfChannel:self.channel];
}

@end
