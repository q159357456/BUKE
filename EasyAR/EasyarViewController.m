//
//  EasyarViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2019/4/25.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "EasyarViewController.h"
#import "ARRecognitionView.h"
#import "ARAudioManager.h"
#import "GuidanceVew.h"
#import "HomeViewController.h"
#import "BookneededScanningCodeVC.h"
#import "ARDownFlieManager.h"
#import "BKCommonShowTipCtr.h"
#import "ARReportUDIDManager.h"
#import "ARReportDB.h"
#import "ARReportUpLoadManager.h"
#import "ARReportEndTimeHandle.h"
#import "BKMemberWebController.h"
@interface EasyarViewController ()<ARAudioManagerDelegate,MusicPlayToolDelegate>
{
    NSTimer *_timer;
    NSInteger _test;
    BOOL _isFoundTarget;
    struct {
        NSString * bookid;
        NSString * pageNum;
    } _currentBookInfo;
}
@property(nonatomic,strong)MemberInfo * memberInfo;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *lastuid;
@property(nonatomic,strong)NSDate * startDate;
@property(nonatomic,strong)NSDate * endDate;
@property(nonatomic,strong)GuidanceVew * guidanceView;
@property(nonatomic,copy)NSString *bookEtdName;
@property(nonatomic,copy)NSString *lastbookEtdName;
@property(nonatomic,copy)NSString *isDowningBookID;
@property(nonatomic,strong)  UIProgressView *progress;
@end

@implementation EasyarViewController
{

    ARRecognitionView *glView;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [MusicPlayTool shareMusicPlay].delegat = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [ARManager onPause];
    [self->glView stop];
    [self->glView stopAndHiddenOtherAnimation];
    self->glView.animationIndex = -1;
    [[ARAudioManager singleton] stopPlay];
    [ARAudioManager singleton].InEasyAR_Working = NO;
    
    self.uid = nil;
    self.bookEtdName = nil;
    [MusicPlayTool shareMusicPlay].delegat = nil;
    
    
}

-(void)restart{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self -> glView startWaitingAnimation];
        [self progressDefaultHide];
    });
    FHWeakSelf;
    [XBKNetWorkManager memberFetchUserInfoFinish:^(MemberModel * _Nonnull model, NSError * _Nonnull error) {
        if (!error) {
            weakSelf.memberInfo = model.data;
            if (![ARAudioManager singleton].InEasyAR_Working) {
                return ;
            }
            if (model.data.isMemberActive) {
                if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
                    //没有授权
                    [self->glView goToCamaraPremission];
                }else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.uid = nil;
                        self.bookEtdName = nil;
                        [ARManager onResume];
                        [self->glView start];
                        
                    });
                    [ARAudioManager singleton].InEasyAR_Working = YES;
                    [[ARAudioManager singleton] playHintVoice];
                }
            }else
            {
                if ([ARAudioManager singleton].isViewWillApear) {
                    [ARAudioManager singleton].isViewWillApear = NO;
                    return;
                }
                
                if (![APP_DELEGATE.window.subviews containsObject:self.guidanceView]) {
                    [APP_DELEGATE.window addSubview:self.guidanceView];
                    if (model.data.isSH) {
                        [self.guidanceView showBuyMember:YES];
                    }else
                    {
                        [self.guidanceView showBuyMember:NO];
                    }
                    
                }
                
            }
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self->glView = [ARRecognitionView singleton];
    self->glView.frame = self.view.bounds;
    [self.view addSubview:self->glView];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [ARAudioManager singleton].delegate = self;
    [ARAudioManager singleton].InEasyAR_Working = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TargetsNotFound:) name:EasyARTargetsNotFound object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActivity:) name:@"applicationWillEnterForeground" object:nil];
  
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ResignActive) name:@"applicationWillResignActive" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ARFoundP0:) name:EasyARLocalFound object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ARFoundPagePlay:) name:EasyARLocalFoundPlay object:nil];

 
    [self deviceCamaraPremission];

    [self->glView.bgView addSubview:self.progress];
    [self progressDefaultHide];

     [APP_DELEGATE.window bringSubviewToFront:[MonitorLogView singleton]];
    // Do any additional setup after loading the view.
}
-(void)setUI{
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(8, kStatusBarH==44?32:18 , 40, 40)];
//    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
}


#pragma mark - 从后台到前台
-(void)becomeActivity:(NSNotification*)notify{
    UIViewController *vc = APP_DELEGATE.navigationController.viewControllers.firstObject;
    NSLog(@"class ==>%@",NSStringFromClass([HomeViewController class]));
    if ([vc.class isEqual:[HomeViewController class]]) {
        HomeViewController *vc =(HomeViewController*) APP_DELEGATE.navigationController.viewControllers.firstObject;
        BOOL temp = vc.currentTabIndex == TabIndex_EnglishView;
        NSLog(@"app从后台到前台__%@__%@",APP_DELEGATE.navigationController.viewControllers,temp?@"是在第二个tab":@"不是在第二个tab");
        if (APP_DELEGATE.navigationController.viewControllers.count != 1 || !temp) {
            self -> glView.animationIndex = -1;
        }else
        {
            [ARAudioManager singleton].InEasyAR_Working = YES;;
            [self restart];
        }
    }
  
   
}
#pragma mark - 即将到后台
-(void)ResignActive{
    [self.guidanceView removeFromSuperview];
    NSLog(@"self.guidanceView移除");
    if (_timer) {
        [_timer invalidate];
    }
}



//TargetsNotFound
-(void)TargetsNotFound:(NSNotification*)notify{
    
    _isFoundTarget = NO;
    if (!self.startDate) {
        self.startDate = [NSDate date];
    }
}

#pragma mark - 开始读绘本
-(void)startReading{
    [[ARAudioManager  singleton] startPlayWithid:self.uid];
}

#pragma mark  - 监听播放结束
-(void)endOfPlayAction{
//    NSLog(@"播放结束");
    if ([[MusicPlayTool shareMusicPlay].urlString isEqualToString:[ARAudioManager  singleton].AR_UnableVoice]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([[MusicPlayTool shareMusicPlay].urlString isEqualToString:[ARAudioManager  singleton].AR_UnableVoice] && [ARAudioManager singleton].InEasyAR_Working)
            {
                [MusicPlayTool shareMusicPlay].urlString = [ARAudioManager  singleton].AR_UnableVoice;
                [[MusicPlayTool shareMusicPlay] musicPrePlay];
            }
            
        });
        
    }else if ([[MusicPlayTool shareMusicPlay].urlString isEqualToString:[ARAudioManager  singleton].AR_HintVoice]){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([[MusicPlayTool shareMusicPlay].urlString isEqualToString:[ARAudioManager  singleton].AR_HintVoice] && [ARAudioManager singleton].InEasyAR_Working)
            {
                [MusicPlayTool shareMusicPlay].urlString = [ARAudioManager  singleton].AR_HintVoice;
                [[MusicPlayTool shareMusicPlay] musicPrePlay];
            }
            
        });
    
    }else if ([[MusicPlayTool shareMusicPlay].urlString isEqualToString:[ARAudioManager  singleton].AR_PagingVoice]){
        
        //开始计时
        _timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(readRepeat:) userInfo:nil repeats:NO];
        
    }else if ([[MusicPlayTool shareMusicPlay].urlString isEqualToString:[ARAudioManager  singleton].AR_DownloadingVoice]){
        
    }else if ([[MusicPlayTool shareMusicPlay].urlString isEqualToString:[ARAudioManager  singleton].AR_TimeUpVoice]){
        //开始计时
        _timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(waiting:) userInfo:nil repeats:NO];

    }
    else
   {
       self.lastuid = self.uid;
       self.lastbookEtdName = self.bookEtdName;
       //开始计时
       _timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(waiting:) userInfo:nil repeats:NO];
   }
    
}

#pragma mark - timer
-(void)waiting:(NSTimer*)timer{
    
    if (![ARAudioManager singleton].InEasyAR_Working) {
         [_timer invalidate];
         return;
    }
    //
    if (!_isFoundTarget && ![ARAudioManager singleton].isReadingBook) {
        //等待
        dispatch_async(dispatch_get_main_queue(), ^{
            [self progressDefaultHide];
            [self -> glView startWaitingAnimation];
        });
       [[ARAudioManager singleton] playHintVoice];

    }
    
   // uid没变判断还没有翻页
    if (_isFoundTarget && self.uid && self.lastuid == self.uid) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //提示翻页
            [self -> glView startHintPagingAnimation];
        });
        [[ARAudioManager singleton] palyHintPagingVoice];
    }
    
    if (_isFoundTarget && self.bookEtdName && [self.bookEtdName isEqualToString:self.lastbookEtdName]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //提示翻页
            [self -> glView startHintPagingAnimation];
        });
        [[ARAudioManager singleton] palyHintPagingVoice];
    }
    [_timer invalidate];
}

-(void)readRepeat:(NSTimer*)timer{
    if (![ARAudioManager singleton].InEasyAR_Working) {
        [_timer invalidate];
        return;
    }
    if (!_isFoundTarget) {
        //等待
        dispatch_async(dispatch_get_main_queue(), ^{
            [self progressDefaultHide];
            [self -> glView startWaitingAnimation];
        });
         [[ARAudioManager singleton] playHintVoice];
    }
    
    if (_isFoundTarget && self.uid && self.lastuid == self.uid){
        if (self -> glView.animationIndex != 1 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self -> glView startReadingAnimation];
            });
        }
        [[ARAudioManager singleton] repeatPlay];;
    }
    
    if (_isFoundTarget && self.bookEtdName && [self.bookEtdName isEqualToString:self.lastbookEtdName]){
        if (self -> glView.animationIndex != 1 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self -> glView startReadingAnimation];
            });
        }
        [[ARAudioManager singleton] repeatPlay];;
    }

    [self progressDefaultHide];
     [_timer invalidate];
}
#pragma mark - ARAudioManagerDelegate
-(void)erro30004
{
    [self -> glView startErroAnimamation];
    [[ARAudioManager singleton] palyUnableVoice];
}
-(void)startPlayingBook
{
    if (self -> glView.animationIndex != 1 ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self -> glView startReadingAnimation];
        });
    }
    
}

#pragma mark 相机相关权限问题
-(void)deviceCamaraPremission{
    [easyar_CameraDevice requestPermissions:[easyar_ImmediateCallbackScheduler getDefault] permissionCallback:^(easyar_PermissionStatus status, NSString *value) {
        switch (status) {
            case easyar_PermissionStatus_Denied:
                [self->glView goToCamaraPremission];
                break;
            case easyar_PermissionStatus_Granted:
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self restart];
                });
            }
                break;
            case easyar_PermissionStatus_Error:
                [self->glView goToCamaraPremission];
                break;
            default:
                break;
        }
    }];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    NSLog(@"deallc");
    [ARAudioManager singleton].InEasyAR_Working = NO;
    [MusicPlayTool shareMusicPlay].delegat = nil;
    [ARAudioManager singleton].delegate = nil;
}

-(GuidanceVew *)guidanceView
{
    if (!_guidanceView) {
        NSArray *array = @[[UIImage imageNamed:@"ar_instructions_iamge00"],[UIImage imageNamed:@"ar_instructions_iamge01"], [UIImage imageNamed:@"ar_instructions_iamge02"]];
        

        _guidanceView = [GuidanceVew showGuidInfo:array Describ:@"" CallBack:^(NSInteger index) {
            if (index == 0) {
                BookneededScanningCodeVC *vc = [[BookneededScanningCodeVC alloc]init];
                [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
            }else
            {
                BKMemberWebController *vc = [[BKMemberWebController alloc]init];
                if (self.memberInfo) {
                        vc.memberInfo = self.memberInfo;
                }
                [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
            }
            
        }];
    }
    return _guidanceView;
    
}

#pragma mark - localARAbout
- (void)ARFoundP0:(NSNotification*)notify{
    _isFoundTarget = YES;
    if (self.startDate && !self.endDate) {
        self.endDate = [NSDate date];
        NSTimeInterval second = [self.endDate timeIntervalSinceDate:self.startDate];
        if (second > 15) {
            //重读
            self.uid = nil;
            _currentBookInfo.bookid = nil;
        }
        self.startDate = nil;
        self.endDate = nil;
    }
    NSArray<easyar_Target *> * targets = (NSArray<easyar_Target *>*)notify.object;
    @synchronized (self.uid) {
        for (easyar_Target * t in targets) {
            if (![self.uid isEqualToString:[t uid]] ) {
                self.uid = [t uid];
                self.bookEtdName = nil;
                [self progressDefaultHide];
                [XBKNetWorkManager requestAR_BookDownDataWithFeatureId:self.uid AndAndFinish:^(ARBookDownModel * _Nonnull model, NSError * _Nonnull error) {
                    if (!error) {
                        if (model.code == 1 && model.data && model.data.bookId.length) {
                            
                            [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"检查下载: bookid: %@,bookurl:%@",model.data.bookId,model.data.dstUrl]];
                            [self startCheckLoadWithModel:model];
                        }else{
                            NSLog(@"%@",model.msg);
                            
                            [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"检查下载: erro msg: %@",model.msg]];
                            
                            self.uid = nil;
                        }
                    }else{
                        self.uid = nil;
                    }
                }];

            }
        }
    }
}

- (void)ARFoundPagePlay:(NSNotification*)notify{
    [self progressDefaultHide];
    _isFoundTarget = YES;
    if (self.startDate && !self.endDate) {
        self.endDate = [NSDate date];
        NSTimeInterval second = [self.endDate timeIntervalSinceDate:self.startDate];
        if (second > 15) {
            //重读
            self.bookEtdName = nil;
        
        }
        self.startDate = nil;
        self.endDate = nil;
    }
    
    NSString *localStr = (NSString*)notify.object;
    if (![localStr isEqualToString:self.bookEtdName]) {
        NSLog(@"localStr===> %@",localStr);
        NSArray *array = [localStr componentsSeparatedByString:@","];
        if (localStr.length && array.count == 3) {
            NSString *bookId = array.firstObject;
            NSString *pageNumber = array[1];
            if ([pageNumber rangeOfString:@"P"].location != NSNotFound) {
                pageNumber = [pageNumber substringFromIndex:([pageNumber rangeOfString:@"P"].location+[pageNumber rangeOfString:@"P"].length)];
            }
            [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"本地识别 bookid:%@,pageNum:%@",bookId,pageNumber]];
            BOOL condition = ![bookId isEqualToString:_currentBookInfo.bookid] || ([bookId isEqualToString:_currentBookInfo.bookid] && _currentBookInfo.pageNum.integerValue != [pageNumber integerValue]);
            if (condition) {
                [self ARFoundPlayWithLocal:bookId and:pageNumber];
                self.bookEtdName = localStr;
                _currentBookInfo.bookid = bookId;
                _currentBookInfo.pageNum = pageNumber;
                [[ARReportEndTimeHandle singleton] updateEndTime];
                ARReportModel * rmodel = [ARReportModel getModelWithEventId:@"1002" Detail:localStr];
                if ( [[ARReportDB defautManager] insertARReportModel:rmodel]) {
                    NSLog(@"插入数据=======>%@",rmodel.description);
                };
                
                [ARReportEndTimeHandle singleton].lastReportModel = rmodel;
            }
            if (![pageNumber isEqualToString:@"0"]) {
                self.uid = nil;
            }
        }else{
            NSLog(@"本地date,name 不符合规范");
        }
    }
    
}

- (void)ARFoundPlayWithLocal:(NSString*)bookId and:(NSString*)pageNumber{
    
    [[ARAudioManager  singleton] startplayTheBookAudioUrlWithBookId:bookId andPage:pageNumber];
}

//开始检查本地load
-(void)startCheckLoadWithModel:(ARBookDownModel*)model{
    
    if ([[ARDownFlieManager shareInstance] CheckTheBookIsNeedDown:model]) {
        NSLog(@"need down");

        BOOL isTipLess = [[ARDownFlieManager shareInstance] checkTheDiskMerrorySizeIsLess];
        if (isTipLess) {//空间不足200M提示
            [self TipTheDiskIsless:model];
        }else{
            [self stratDownTheZip:model];
        }
       
    }else{
        NSLog(@" dont need down");
        
        [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"不需要下载bookid:%@",model.data.bookId]];
        NSString *path = [[ARDownFlieManager shareInstance] GetTheBookSavePath:model];
        addTracker(path);
        if (![model.data.bookId isEqualToString:_currentBookInfo.bookid]) {
            [[ARReportUDIDManager singleton] updateUDID];
            [ARReportUpLoadManager uploadReport];
        }
        BOOL condition = path.length && (![model.data.bookId isEqualToString:_currentBookInfo.bookid] || ([model.data.bookId isEqualToString:_currentBookInfo.bookid] && _currentBookInfo.pageNum.integerValue != 0));
        if (condition) {
            [self ARFoundPlayWithLocal:model.data.bookId and:@"0"];
            _currentBookInfo.bookid = model.data.bookId;
            _currentBookInfo.pageNum = @"0";
            [[ARReportEndTimeHandle singleton] updateEndTime];
            NSString * detail = [NSString stringWithFormat:@"%@,0,P0",model.data.bookId];
            ARReportModel * rmodel = [ARReportModel getModelWithEventId:@"1001" Detail:detail];
            if ( [[ARReportDB defautManager] insertARReportModel:rmodel]) {
                 NSLog(@"插入数据=======>%@",rmodel.description);
            };
            [ARReportEndTimeHandle singleton].lastReportModel = rmodel;
           
        }
       
    }
    
}

/**提示空间不足*/
- (void)TipTheDiskIsless:(ARBookDownModel*)model{
    BKCommonShowTipCtr *ctr = [[BKCommonShowTipCtr alloc]init];
    [ctr showWithTitle:@"手机空间不足" andsubTitle:@"手机储存空间即将不足,请删\n除/卸载一些程序或数据" andLeftBtntitel:@"我知道了" andRightBtnTitle:@"" andIsTap:NO AndLeftBtnAction:^{
        [self stratDownTheZip:model];
    } AndRightBtnAction:^{
        
    }];
    [ctr startShowTipWithController:self];
}

/**开始下载zip*/
- (void)stratDownTheZip:(ARBookDownModel*)model{
    if (model == nil) {
        return;
    }
    if (self.isDowningBookID) {
        [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"取消下载:%@",self.isDowningBookID]];
        [[ARDownFlieManager shareInstance] cancelDownBook];
    }
    self.isDowningBookID = model.data.bookId;
    
    [self startDownStep];
    [[ARDownFlieManager shareInstance] downFlieWithURLStr:model Andprogress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat pro =downloadProgress.completedUnitCount*1.0/downloadProgress.totalUnitCount;
//        NSLog(@"下载进度:%lf",pro);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progress setProgress:pro animated:YES];
        });
        
    } AndFinish:^(NSString * _Nonnull path,NSString * bookId, BOOL success) {
        
        if (success && path.length) {
    
            //下载保存成功.
            self.uid = nil;
            NSLog(@"下载保存成功");
            
            [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"下载成功booid:%@",model.data.bookId]];
            
            if ([self.isDowningBookID isEqualToString:bookId]) {
            [MonitorLogView showMonitorLog:@"开始下载成功动画和语音"];
                [self DownIsOKStep];
            }
            
        }else{
            //下载保存失败.
            NSLog(@"下载失败");
            
            [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"下载失败booid:%@",model.data.bookId]];
            
            if ([self.isDowningBookID isEqualToString:bookId]) {
                [MonitorLogView showMonitorLog:@"开始下载失败动画和语音"];
                [self DownIsNOStep];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.uid = nil;
                });
            }else{
                self.uid = nil;
            }
            
        }
        self.isDowningBookID = nil;
    }];
}

- (void)startDownStep{
    //开始下载动画
    [[ARAudioManager singleton] playStartDownloadingVoice];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self -> glView startDownLoadingAnimation];
        self.progress.progress = 0;
        self.progress.hidden = NO;
    });
}
- (void)DownIsOKStep{
    //下载成功动画
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[MusicPlayTool shareMusicPlay].urlString isEqualToString:[[NSBundle mainBundle] pathForResource:@"我正在努力下载" ofType:@"wav"]] && [MusicPlayTool shareMusicPlay].isPlaying) {
            [[ARAudioManager singleton] stopPlay];
        }
        [self -> glView startDownLoadSuccessAnimation];
    });
}
- (void)DownIsNOStep{
    //下载失败动画
    [self progressDefaultHide];
    [[ARAudioManager singleton] playDownLoadTimeUpVoice];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self -> glView startDownLoadFaildAnamation];
    });
}

- (UIProgressView *)progress
{
    if (_progress == nil)
    {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self->glView.bgView.frame), SCREEN_WIDTH, 4)];
        _progress.progressTintColor = COLOR_STRING(@"#7cc597");
        _progress.trackTintColor =COLOR_STRING(@"#FAFAFA");
    }
    return _progress;
}
- (void)progressDefaultHide{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progress.hidden = YES;
        self.progress.progress = 0;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

@end
