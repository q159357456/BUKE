//
//  RecordTool.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/20.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

/**
 *  录音类型
 */
typedef NS_ENUM(NSInteger, RecordType){
    RecordTypeKbook = 1,//K绘本录音
    RecordTypeTalk,//说说
};

// 录音结束回调
typedef void(^RecordVoiceFinishBlock)(NSString* wavpath,NSString *mp3Path,float recordTime);

//转换声音完成后回调
typedef void (^RecordConvertBlock)(NSString *errorInfo);

#undef AS_SINGLETON

#define AS_SINGLETON( __class ) \
- (__class *)sharedInstance; \
+ (__class *)sharedInstance;
#undef DEF_SINGLETON

#define DEF_SINGLETON( __class ) \
- (__class *)sharedInstance \
{ \
return [__class sharedInstance]; \
} \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
return __singleton__; \
} \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once(&once, ^{ __singleton__ = [super allocWithZone:zone]; } ); \
return __singleton__; \
}

//录音工具类
@interface RecordTool : NSObject

AS_SINGLETON(RecordTool)


@property (nonatomic, strong) AVAudioRecorder *recorder;
//文件存储的路径,需要带文件名和文件后缀,如果没有会是默认值
@property (nonatomic, strong) NSString *savePath;
// 转换成MP3文件的存储路径
@property (nonatomic, strong) NSString *mp3SavePath;
//录音配置字典,如果不设置将会默认值
@property (nonatomic, strong) NSDictionary *recordConfigDic;

@property (nonatomic,assign) NSTimeInterval currentTime;

// 录音结束回调
@property (nonatomic, copy) RecordVoiceFinishBlock finishBlock;

@property (nonatomic, assign) RecordType recordType;

// 开始录音
-(void)startRecordVoice;
// 结束录音
-(void)stopRecordVoice;
// wav格式转换MP3
+(void)convertWavToMp3:(NSString*)wavFilePath withSavePath:(NSString*)savePath withBlock:(RecordConvertBlock)block;

@end
