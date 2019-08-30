//
//  RCTalkRecordTool.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "RCTalkRecordTool.h"
#import "lame.h"


#define RecordMaxTime  (1.0 * 99.0)

@interface RCTalkRecordTool()<AVAudioRecorderDelegate>

@property(nonatomic,copy) NSString *wavPath;
@property (nonatomic, copy) NSString *mp3Path;

@end


@implementation RCTalkRecordTool

DEF_SINGLETON(RCTalkRecordTool)


-(void)startRecordVoice
{
    if (!self.savePath) {
        self.savePath = [self getCacheTalkVoice];
    }
    
    NSString * time = [self getCurrentTime:@"YYYYMMddHHmmss"];
    self.wavPath = [NSString stringWithFormat:@"%@/%@.wav",self.savePath,time];
    
    if (!self.mp3SavePath) {
        self.mp3SavePath = [self getCacheTalkVoice];
    }
    self.mp3Path = [NSString stringWithFormat:@"%@/%@.mp3",self.mp3SavePath,time];
    
    if (!self.recordConfigDic) {
        self.recordConfigDic = [self getConfig];
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    NSError *error = nil;
    NSURL * url = [NSURL URLWithString:self.wavPath];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:self.recordConfigDic error:&error];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder recordForDuration:(NSTimeInterval) RecordMaxTime];
    [self.recorder record];
    self.currentTime = self.recorder.currentTime;
    
}

//融云 语音配置
-(NSDictionary *)getConfig
{
    NSDictionary *result = nil;
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
    
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsNonInterleaved];
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    
    result = [NSDictionary dictionaryWithDictionary:recordSetting];
    return result;
}

//停止录音
-(void)stopRecordVoice
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
}

//转换MP3格式
+(void)convertWavToMp3:(NSString*)wavFilePath withSavePath:(NSString*)savePath withBlock:(RecordConvertBlock)block
{
    @try {
        int read, write;
        
        FILE *pcm = fopen([wavFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        if(pcm == nil){
            return;
        }
        fseek(pcm, 4*1024,SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([savePath cStringUsingEncoding:1], "wb+");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_num_channels(lame,1);
        lame_set_in_samplerate(lame, 8000);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);
        
        lame_mp3_tags_fid(lame, mp3);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            block(exception.reason);
        });
        
    }
    @finally {
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            NSLog(@"MP3生成成功: %@",savePath);
            
            block(nil);
        });
        
        //删除原wav文件
        [[self alloc] deletePath:wavFilePath];
    }
}

#pragma mark - 工具方法
// 系统时间
- (NSString*)getCurrentTime:(NSString*)formatter
{
    NSDate *senddate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}

-(NSString *)getCacheTalkVoice
{
    NSString * voice = [NSString stringWithFormat:@"%@/TalkVoice",[self getCachePath]];
    if (![self isFileExit:voice]) {
        [self createPath:voice];
    }
    return voice;
}

- (NSString*)getCachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

//检测文件是否存在
-(BOOL)isFileExit:(NSString*)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

-(void)createPath:(NSString*)path
{
    if (![self isFileExit:path]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *parentPath = [path stringByDeletingLastPathComponent];
        if ([self isFileExit:parentPath]) {
            NSError * error;
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:path attributes:nil error:&error];
        }else{
            [self createPath:parentPath];
            [self createPath:path];
        }
    }
}

//删除文件
-(void)deletePath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isHave = [self isFileExit:path];
    if (!isHave) {
        return;
    }else {
        BOOL dele = [fileManager removeItemAtPath:path error:nil];
        if (dele) {
            NSLog(@"删除原文件成功");
        }else{
            NSLog(@"删除原文件失败");
        }
    }
}

#pragma mark - AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.wavPath] options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
//    self.finishBlock(self.wavPath, audioDurationSeconds);
    self.finishBlock(self.wavPath, self.mp3Path, audioDurationSeconds);
}

@end
