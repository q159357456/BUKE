//
//  ARAudioManager.m
//  MiniBuKe
//
//  Created by chenheng on 2019/4/26.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "ARAudioManager.h"
#import "AFNetworking.h"
#import "ARRecognitionView.h"
#import "CommonUsePackaging.h"
#import "ARDownFlieManager.h"
#import "ARManager.h"
static NSString * aesKey = @"ojKlcnhTTjlBVFRd";
@interface ARAudioManager()
//@property(nonatomic,copy)NSString * bookId;
@property(nonatomic,assign)NSInteger  code;
@property(nonatomic,copy)NSString * pages;
@property(nonatomic,copy)NSString * lastAudioURL;
@end
@implementation ARAudioManager
{
    NSURLSessionDataTask *_task;
}
static ARAudioManager * _audioManager = nil;
#pragma mark - public
+(instancetype)singleton{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _audioManager = [[super allocWithZone:nil]init];
    });
    return _audioManager;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [ARAudioManager singleton];
}

//开始播放
-(void)startPlayWithid:(NSString *)featureid
{
    NSLog(@"startPlayWithid ===>%@", featureid);
   
}

//-(void)startPlayWithid:(NSString *)featureid
//{
//
//    NSLog(@"featureid===>%@",featureid);
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    NSString *path = self.bookId && self.pageNumber ?[NSString stringWithFormat:@"%@/book/ar/page/%@?bookId=%@&pageNumber=%@",BeforeHandEnv_URL,featureid,self.bookId,self.pageNumber]:[NSString stringWithFormat:@"%@/book/ar/page/%@",BeforeHandEnv_URL,featureid];
////    NSDictionary * params = @{@"bookId":self.bookId,@"pageNumber":self.pageNumber};
//    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:nil error:nil];
//    request.timeoutInterval = 10.f;
//    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"Authorization"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    _task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSDictionary *dic = (NSDictionary*)responseObject;
//        NSLog(@"dic===>%@",dic);
//        if ([dic[@"code"] integerValue] == 30004 && self.code != 30004) {
//            //如果没有识别到之前 一直循环播放此句话
//            //不认识这本书
//            [self.delegate erro30004];
//        }
//
//        //
//        if ([dic[@"code"] integerValue] == 1) {
//            if (dic[@"data"]) {
//                NSString * url = [[CommonUsePackaging shareInstance] decryptStringWithString:dic[@"data"] andKey:aesKey];
//                NSLog(@"dicdic===>%@",url);
//                NSDictionary * audioDic = [self dictionaryWithJsonString:url];
//                NSString *musicUrl = audioDic[@"audioUrl"];
//                self.bookId = audioDic[@"bookId"];
//                if ([self.pageNumber integerValue] != [audioDic[@"pageNum"] integerValue]) {
//                    if (musicUrl&&musicUrl.length) {
//                        [self.delegate startPlayingBook];
//                        [MusicPlayTool shareMusicPlay].urlString = musicUrl;
//                        [[MusicPlayTool shareMusicPlay] musicPrePlay];
//                        self.lastAudioURL = musicUrl;
//
//                    }else
//                    {
//                        NSLog(@"url ====> %@",musicUrl);
//                        //先让我看看封面
////                        [self playHintVoice];
//                    }
//                }
//                self.pageNumber = audioDic[@"pageNum"];
//                self.pages = audioDic[@"pages"];
//            }
//
//        }else
//        {
//            NSLog(@"%@",dic[@"msg"]);
//        }
//        //
//
//        self.code = [dic[@"code"] integerValue];
//    }];
//    [_task resume];
//
//
//}
//停止播放
-(void)stopPlay
{
    [[MusicPlayTool shareMusicPlay] musicPause];
    [self endServerRequest];
    
}

//队列停止当前请求
-(void)endServerRequest{
    
    [_task cancel];
    
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
     if (jsonString == nil) {
         return nil;
     }
    
     NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
     NSError *err;
     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
       if(err) {
           return nil;
       }
      return dic;
}


//播放提示读封面语音
-(void)playHintVoice{
    

    [MusicPlayTool shareMusicPlay].urlString = self.AR_HintVoice;
    [[MusicPlayTool shareMusicPlay] musicPrePlay];
    
}
//播放不能识别的语音
-(void)palyUnableVoice{
    

    [MusicPlayTool shareMusicPlay].urlString = self.AR_UnableVoice;
    [[MusicPlayTool shareMusicPlay] musicPrePlay];
    
}
//播放提示翻页语音
-(void)palyHintPagingVoice;{
    
    [MusicPlayTool shareMusicPlay].urlString = self.AR_PagingVoice;
    [[MusicPlayTool shareMusicPlay] musicPrePlay];
}

-(void)repeatPlay{
    if (self.lastAudioURL) {
        [MusicPlayTool shareMusicPlay].urlString = self.lastAudioURL;
        [[MusicPlayTool shareMusicPlay] musicPrePlay];
    }
   
}

//播放开始下载语音
-(void)playStartDownloadingVoice{
    
    [MusicPlayTool shareMusicPlay].urlString = self.AR_DownloadingVoice;
    [[MusicPlayTool shareMusicPlay] musicPrePlay];
}

//播放下载超时语音
-(void)playDownLoadTimeUpVoice{
    
    [MusicPlayTool shareMusicPlay].urlString = self.AR_TimeUpVoice;
    [[MusicPlayTool shareMusicPlay] musicPrePlay];
    
}

//是否正在播绘本
-(BOOL)isReadingBook{
    
    if (([[MusicPlayTool shareMusicPlay].urlString hasPrefix:@"http"] || [[MusicPlayTool shareMusicPlay].urlString hasPrefix:@"https"]) && [MusicPlayTool shareMusicPlay].isPlaying) {
        return YES;
    }else
    {
        return NO;
    }
}

#pragma mark - lazy
//-(void)setBookId:(NSString *)bookId
//{
//    NSLog(@"self.bookId===>%@",self.bookId);
//    NSLog(@"bookId===>%@",bookId);
//    if (![[NSString stringWithFormat:@"%ld",(long)self.bookId] isEqualToString:[NSString stringWithFormat:@"%ld",(long)bookId]]) {
//        self.pageNumber = @"-1";
//    }
//    _bookId = bookId;
//}
//-(NSString *)pageNumber
//{
//    if (!_pageNumber) {
//        _pageNumber = @"-1";
//    }
//    return _pageNumber;
//}
-(NSString *)AR_HintVoice
{
    if (!_AR_HintVoice) {
       _AR_HintVoice = [[NSBundle mainBundle] pathForResource:@"先让我看看封面" ofType:@"wav"];
    }
    return _AR_HintVoice;
}
-(NSString *)AR_UnableVoice
{
    if (!_AR_UnableVoice) {
        
         _AR_UnableVoice = [[NSBundle mainBundle] pathForResource:@"这本书我还不会,等我学会了,再陪你读吧" ofType:@"wav"];
    }
    return _AR_UnableVoice;
}
-(NSString *)AR_PagingVoice
{
    if (!_AR_PagingVoice) {
        _AR_PagingVoice = [[NSBundle mainBundle] pathForResource:@"提示翻页" ofType:@"mp3"];
    }
    return _AR_PagingVoice;
}
-(NSString *)AR_TimeUpVoice
{
    if (!_AR_TimeUpVoice) {
        _AR_TimeUpVoice = [[NSBundle mainBundle] pathForResource:@"下载超时了" ofType:@"wav"];
    }
    return _AR_TimeUpVoice;
}
-(NSString *)AR_DownloadingVoice
{
    if (!_AR_DownloadingVoice) {
        _AR_DownloadingVoice = [[NSBundle mainBundle] pathForResource:@"我正在努力下载" ofType:@"wav"];
    }
    return _AR_DownloadingVoice;
}

/*
 1.未识别封面就识别内页,返回错误码30004; 2.识别到页面,但是没有音频资源; 3.在等待状态  4.待翻页状态
 

 处理:  // 状态1. 播放这本书我还不会 (每隔5秒钟播放一次,直到识别到可读音频)
       // 状态2. 同状态1
       // 状态3. 播放先让我看看封面
       // 状态4. 播放提示翻页音频(这个没有)
 
 */

#pragma mark - 本地识别相关
/**播放音频url*/
- (void)startplayTheBookAudioUrlWithBookId:(NSString*)bookId andPage:(NSString*)pageNumber{
    [XBKNetWorkManager requestAR_BookAudioWith:bookId PageNumber:pageNumber AndAndFinish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if (error == nil) {
            NSDictionary *dic = (NSDictionary*)responseObj;
            if ([dic[@"code"] integerValue] == 1) {
                if (dic[@"data"]) {
                    NSString * url = [[CommonUsePackaging shareInstance] decryptStringWithString:dic[@"data"] andKey:aesKey];
                    NSLog(@"dicdic===>%@",url);
                    NSDictionary * audioDic = [self dictionaryWithJsonString:url];
                    NSString *musicUrl = audioDic[@"audioUrl"];
//                    self.bookId = audioDic[@"bookId"];
//                    if ([self.pageNumber integerValue] != [audioDic[@"pageNum"] integerValue]) {
                    
                        [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"准备播放: %@",musicUrl]];
                    
                        if (musicUrl&&musicUrl.length) {
                            [self.delegate startPlayingBook];
                            [MusicPlayTool shareMusicPlay].urlString = musicUrl;
                            [[MusicPlayTool shareMusicPlay] musicPrePlay];
                            self.isRead = YES;
                            self.lastAudioURL = musicUrl;
                        }else{
//                            NSLog(@"url ====> %@",musicUrl);
//                            //先让我看看封面
//                            [self playHintVoice];
                        }
                        
//                    }
//                    self.pageNumber = audioDic[@"pageNum"];
//                    self.pages = audioDic[@"pages"];
                }
                
            }else
            {
                
                [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"准备播放: erro msg:%@",dic[@"msg"]]];
                
                NSLog(@"%@",dic[@"msg"]);
            }
        }
    }];
}

@end
