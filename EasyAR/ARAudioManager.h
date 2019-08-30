//
//  ARAudioManager.h
//  MiniBuKe
//
//  Created by chenheng on 2019/4/26.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicPlayTool.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ARAudioManagerDelegate <NSObject>
@optional
-(void)erro30004;
-(void)startPlayingBook;
@end
@interface ARAudioManager : NSObject
+(instancetype)singleton;
//开始播放
-(void)startPlayWithid:(NSString*)featureid;
//停止播放
-(void)stopPlay;
//播放提示读封面语音
-(void)playHintVoice;
//播放不能识别的语音
-(void)palyUnableVoice;
//播放提示翻页语音
-(void)palyHintPagingVoice;
//播放开始下载语音
-(void)playStartDownloadingVoice;
//播放下载超时语音
-(void)playDownLoadTimeUpVoice;
//重播
-(void)repeatPlay;
//是否正在播绘本
-(BOOL)isReadingBook;
@property(nonatomic,copy)NSString* AR_HintVoice;
@property(nonatomic,copy)NSString* AR_UnableVoice;
@property(nonatomic,copy)NSString* AR_PagingVoice;
@property(nonatomic,copy)NSString* AR_DownloadingVoice;
@property(nonatomic,copy)NSString* AR_TimeUpVoice;;
@property(nonatomic,assign)BOOL InEasyAR_Working;
//@property(nonatomic,copy)NSString * pageNumber;
@property(nonatomic,assign)BOOL isRead;
//此参数判断是否是tab切换过来,还是返回出来
@property(nonatomic,assign)BOOL isViewWillApear;
@property(nonatomic,assign)id<ARAudioManagerDelegate>delegate;


/**播放音频url*/
- (void)startplayTheBookAudioUrlWithBookId:(NSString*)bookId andPage:(NSString*)pageNumber;

@end


NS_ASSUME_NONNULL_END
