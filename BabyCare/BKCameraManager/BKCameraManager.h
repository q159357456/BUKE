//
//  BKCameraManager.h
//  babycaretest
//
//  Created by Don on 2019/4/18.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//
// babycare设备管理单例
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BKCameraHelp.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BKCameraManagerDelegtae <NSObject>

@optional
/**视频信息参数回调*/
- (void)BkCameradidReceiveFrameInfoWithvideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount isHwDecode:(BOOL)isHwDecode;
/**设备状态改变回调*/
- (void)BKCameraDeviceStateInfoWithContentState:(DeviceContentStateType)contentState;
/**设备视频状态回调*/
- (void)BKCameraDeviceStateInfoWithIsVideoShow:(BOOL)isVideoShow;
/**设备监听状态回调*/
- (void)BKCameraDeviceStateInfoWithIsListen:(BOOL)isListen;
/**设备通话状态回调*/
- (void)BKCameraDeviceStateInfoWithIsTalk:(BOOL)isTalk;

- (void)BKCameraDeviceDidStartShowVideo;
- (void)BKCameraDeviceWillStartShowVideo;

/**设备通话命令非正常回调*/
- (void)BKCameraDeviceTalkError;
/*发送CMD回调*/
- (void)BKCameraDevicedidSendIOCtrlResult:(BOOL)success channel:(NSInteger)channel type:(NSInteger)type;
/*开启监控是否成功回调*/
- (void)BKCameraDevicedidStartShowResult:(BOOL)success channel:(NSInteger)channel;

@end

@interface BKCameraManager : NSObject

@property (nonatomic, weak)  id<BKCameraManagerDelegtae>  managerDelegate;
@property (nonatomic, assign) BOOL isReadyTalk; //设备是否可以通话
@property (nonatomic, assign) BOOL isListen;
@property (nonatomic, assign) BOOL isTalk;
@property (nonatomic, assign) BOOL isVideoShow;
@property (nonatomic, assign) BOOL isStartShow;
@property (nonatomic, assign) BOOL isHardDecode ; //是否支持硬解码
@property (nonatomic, assign) DeviceContentStateType deviceState;//设备状态

@property (nonatomic, assign) NSInteger talkStepflag;
@property (nonatomic, assign) NSInteger isInManagerView;//是否在babycare视频页面

+(instancetype)shareInstance;

@property (nonatomic, strong) AVSampleBufferDisplayLayer *sampleBufferDisplayLayer; //显示视频图层

/**初始化设备连接*/
-(void)CameraInitializeWithUID:(NSString*)uid Pwd:(NSString*)pwd Account:(NSString*)account Channel:(NSInteger)channel;

/**开始连接设备*/
-(void)ConnectDevice;
/**断开设备连接*/
-(void)DisconnectDevice;

/**开启视频监控*/
-(void)StartShowVideoWithView:(UIImageView*)showView;
/**关闭视频监控*/
-(void)StopShowVideo;

/**开启监听*/
-(void)StartListenAudio;
/**关闭监听*/
-(void)StopListenAudio;

-(void)changeTheVolumeIsOpen:(BOOL)isOpen;

/**开启通话*/
-(void)StartTalkToDevice;
/**关闭通话*/
-(void)StopTalkToDevice;

/**被叫接通通话*/
- (void)AnswerTalkToDevice;

/**截屏*/
-(UIImage*)SnapShotImage;

/**刷新显示图层frame*/
- (void)reloadTheShowLayer;

#pragma mark - 通话CMD指令
/**检查设备通话是否占线*/
- (void)checkDeviceIsTalkBusy;
/**设备来电响铃*/ //3.5S再发送对讲的命令,进行通话
- (void)deviceStartRinging;
/**接听设备来电*/
- (void)answerTheDeviceTalk;
/**拒绝设备来电*/
- (void)refuseTheDeviceTalk;

#pragma mark - 歌曲推送CMD指令
/**推送单首歌曲到设备播放*/
- (void)pushMP3ToDeviceWithUrl:(NSString*)url;
/**推送多首歌曲到设备播放*/
- (void)pushMP3SToDeviceWithUrls:(NSArray*)urls;
/**停止播放*/
- (void)stopDevicePlayMP3;
#pragma mark - 设备信息相关CMD指令
/**设备相关信息*/
- (void)postGetTheDeviceInfoCMD;
/**获取设备音量*/
- (void)postGetTheDeviceVolumeCMD;
/**设置设备音量 0-100*/
- (void)postSetTheDeviceVolumeCMDWith:(NSInteger)vol;
/**发送设备更新通讯录信息指令*/
- (void)postTheDeviceFamilyListUpdate;

/**设备播放下一首控制指令*/
- (void)postDeviceNextPlayMusicCMD;
/**设备播放上一首控制指令*/
- (void)postDevicePreviousPlayMusicCMD;
/**设备播放音乐控制指令*/
- (void)postDevicePlayMusicCMD;
/**设备播放停止控制指令*/
- (void)postDeviceStopPlayMusicCMD;

/**获取设备连线channel 的状态*/
- (NSInteger)getTheChanelStateWithChanel;

@end

NS_ASSUME_NONNULL_END
