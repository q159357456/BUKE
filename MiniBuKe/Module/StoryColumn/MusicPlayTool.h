//
//  MusicPlayTool.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol MusicPlayToolDelegate<NSObject>


@optional
//播放结束
-(void)endOfPlayAction;

-(void)getCurTiem:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress;

@end

@interface MusicPlayTool : NSObject

@property(nonatomic,assign) id delegat;
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,copy) NSString *urlString;//音乐地址
@property(nonatomic,assign)BOOL isPlaying;

+(instancetype)shareMusicPlay;

-(void)musicPlay;

-(void)musicPause;

-(void)musicPrePlay;

-(BOOL)PlayStatuse;

//拓展

-(void)seekToTimeWithValue:(CGFloat)value;

- (void)removeObserverStatus;

@end
