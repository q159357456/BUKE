//
//  MusicPlayTool.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "MusicPlayTool.h"
#import "MBProgressHUD+XBK.h"
#import "XYDMSetting.h"
static MusicPlayTool *playTool = nil;
/**
 An instance 0x17401c650 of class AVPlayerItem was deallocated while key value observers were still registered with it. Current observation info: <NSKeyValueObservationInfo 0x170437cc0> ( <NSKeyValueObservance 0x1746485b0: Observer: 0x174642d90, Key path: status, Options: <New: YES, Old: YES, Prior: NO> Context: 0x0, Property: 0x1746485e0> )
 MiniBuKe + 1768240
 */
@interface MusicPlayTool()

@property(nonatomic,strong) NSTimer *timer;//监听播放状态定时器
@property(nonatomic,strong)AVPlayerItem *item;//秦添加
@end

@implementation MusicPlayTool

+(instancetype)shareMusicPlay
{
    if (playTool == nil) {
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            playTool = [[MusicPlayTool alloc]init];
        });
    }
    
    return playTool;
}
-(BOOL)PlayStatuse{
    
    return _player.rate;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        
        _player = [[AVPlayer alloc]init];
        [_player setVolume:1.0];
        
        if (@available(iOS 10.0, *)) {
            [_player setAutomaticallyWaitsToMinimizeStalling:NO];
        } else {
            // Fallback on earlier versions
        }
        //播放结束监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    
    return self;
}

-(void)endOfPlay:(NSNotification *)sender
{
    [self musicPause];
    [self.delegat endOfPlayAction];
}
- (void)removeObserverStatus{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
}
-(void)musicPrePlay
{
    //关掉喜马拉雅播放器
    if ([XYDMSetting IsPlaying]) {
        [XYDMSetting pause];
    }
    //只要AVPlayer有currentItem,那么一定被添加了观察者
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    NSLog(@"self.urlString ===> %@",self.urlString);
    
//    AVPlayerItem *item;
    self.item = nil;//秦
    if ([self.urlString containsString:@"http"] || [self.urlString containsString:@"https"]) {
        //在线播放
        NSString *encodedString =  self.urlString;
//        NSString *encodedString = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"1aaencodedString ===> %@",encodedString);
        self.item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:encodedString]];
        
    }else{
        //本地播放
        
       
        AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.urlString] options:nil];
        self.item = [AVPlayerItem playerItemWithAsset:asset];
        
    }
    
    //给item 的status 添加监听
    [self.item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    
    //替换player 的item
    [self.player replaceCurrentItemWithPlayerItem:self.item];
    self.isPlaying = YES;
}


//监听方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        switch ([[change valueForKey:@"new"] integerValue]) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"播放未知错误");
                 self.isPlaying = NO;
                break;
            case AVPlayerItemStatusReadyToPlay:
                if (self.isPlaying) {
                     [self musicPlay];
                }
                break;
            case AVPlayerItemStatusFailed:
                // mini设备不插耳机或者某些耳机会导致准备失败.
                NSLog(@"准备失败");
                self.isPlaying = NO;
                NSLog(@"self.player.error.description--->%@",self.player.currentItem.error.description);
                [MBProgressHUD showText:@"获取音频失败，请稍后重试"];
                break;
            default:
                break;
        }
    }
}

-(void)musicPlay
{
    
    //如果计时器已经存在了,说明已经在播放中,直接返回.
    if (self.timer != nil) {
        return;
    }
    
    //播放后 开启定时器
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [self.player play];
}

-(void)musicPause
{
    self.isPlaying = NO;
    [self.timer invalidate];
    self.timer = nil;
    [self.player pause];
    [self.player seekToTime:CMTimeMake(0, 1)];
}

-(void)seekToTimeWithValue:(CGFloat)value
{
    [self musicPause];
    [self.player seekToTime:CMTimeMake(value * [self getTotleTime], 1) completionHandler:^(BOOL finished) {
        
        if (finished == YES) {
            [self musicPlay];
        }
        
    }];
}

-(void)timerAction:(NSTimer * )sender
{
    //不断的调用代理方法,将播放进度返回出去
    if (self.delegat && [self.delegat respondsToSelector:@selector(getCurTiem:Totle:Progress:)]) {
        
        [self.delegat getCurTiem:[self valueToString:[self getCurTime]] Totle:[self valueToString:[self getTotleTime]] Progress:[self getProgress]];
    }
}

// 获取当前的播放时间
-(NSInteger)getCurTime
{
    if (self.player.currentItem) {
        // 用value/scale,就是AVPlayer计算时间的算法. 它就是这么规定的.
        // 下同.
        return self.player.currentTime.value / self.player.currentTime.timescale;
    }
    return 0;
}

-(NSInteger)getTotleTime
{
    CMTime totleTime = [self.player.currentItem duration];
    if (totleTime.timescale == 0) {
        return 1;
    }else{
        return totleTime.value /totleTime.timescale;
    }
}

-(CGFloat)getProgress
{
    return (CGFloat)[self getCurTime] / (CGFloat)[self getTotleTime];
}

// 将整数秒转换为 00:00 格式的字符串
-(NSString *)valueToString:(NSInteger)value
{
    return [NSString stringWithFormat:@"%.2ld:%.2ld",value/60,value%60];
}

-(void)dealloc{
    [self.item removeObserver:self forKeyPath:@"status"];//秦加
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.timer invalidate];
    self.timer = nil;
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
