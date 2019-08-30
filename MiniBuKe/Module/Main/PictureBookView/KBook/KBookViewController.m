//
//  KBookViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookViewController.h"
#import "KBookPageService.h"
#import <AVFoundation/AVFoundation.h>
#import "RecordTool.h"
#import "MusicPlayTool.h"
#import "KBookVoiceService.h"
#import "KBookVoiceInfo.h"
#import "KBookCollectionLayout.h"
#import "KBookRecordAnimationView.h"
#import "lame.h"
#import "MBProgressHUD+XBK.h"
#import "KbookVoiceAddService.h"
#import "KbookUploadService.h"
#import "KBookListViewController.h"
#import "XYDMSetting.h"
#define bottomView_height 160
#define ITEM_WIDTH  250
#define ITEM_HEIGHT 200

#define ETRECORD_RATE 11025.0

#define Recording_Time 301.0

#define KBOOK_AUDIOPATH @"KbookAudioData"
#import "JDOSSUploadfileHandle.h"
typedef enum ButtonClickType {
    ButtonClickRecordStart = 1,
    ButtonClickRecordStop = 2,
    ButtonClickNewRecord = 3,
    ButtonClickNewRecordStop = 4
} ButtonClickType;

typedef enum AlertType {
    Alert_Record = 1,
    Alert_Service = 2,
    Alert_Quit = 3
} AlertType;

//转换声音完成后回调
typedef void (^mp3ConvertBlock)(NSString *errorInfo,NSInteger pageNum,NSString *mp3Path,NSString *savePath);

@interface KBookViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,AVAudioRecorderDelegate,MusicPlayToolDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,assign) NSInteger totalPage;

@property(nonatomic,assign) NSInteger curIndex;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UIImageView *bgImageView;
@property(nonatomic,strong) UILabel *pageNumLabel;

@property(nonatomic,strong) UIButton *recordButton;
@property(nonatomic,strong) UIView *leftView;
@property(nonatomic,strong) UIButton *playButton;
@property(nonatomic,strong) UIImageView *playImageView;
@property(nonatomic,strong) UILabel *leftLabel;
@property(nonatomic,strong) UIView *nextView;
@property(nonatomic,strong) UIButton *nextButton;
@property(nonatomic,strong) UIImageView *nextImageview;
@property(nonatomic,strong) UILabel *nextLabel;
@property(nonatomic,strong) UIView *finishView;
@property(nonatomic,strong) UIButton *finishButton;
@property(nonatomic,strong) UIImageView *finishImgView;
@property(nonatomic,strong) UILabel *finishLabel;

@property(nonatomic,strong) UIImageView *recordImage;

//记录点击次数 --> 切换button
@property(nonatomic,assign) NSInteger recordNum;

@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,copy) NSArray *dataArray;
@property(nonatomic,copy) NSArray *totalArray;//记录dataArray里面的sortNUm
@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,strong) NSMutableArray *mp3PathArray;
@property(nonatomic,strong) NSMutableArray *ossArray;

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSTimer *playTimer;

@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) KBookRecordAnimationView *animationView;

@property(nonatomic,strong) AVAudioRecorder *recorder;
@property(nonatomic,copy) NSString *savePath;

@property(nonatomic,strong) UIView *alertMaskView;
@property(nonatomic,strong) UIView *recordAlertView;
@property(nonatomic,strong) UIView *serviceAlertView;
@property(nonatomic,strong) UIView *quitAlertView;
@property(nonatomic,strong) UIImageView *noTipImageView;
@property(nonatomic,strong) UIButton *noTipButton;

@property(nonatomic,strong) NSLock *lock;

@property(nonatomic,strong) NSTimer *recordTimer;
@property(nonatomic,assign) NSInteger recordDuration;

@property int retainCountForThread;

@end

@implementation KBookViewController

-(NSMutableArray *)mp3PathArray
{
    if (!_mp3PathArray) {
        _mp3PathArray = [NSMutableArray array];
    }
    return _mp3PathArray;
}

-(NSMutableArray *)ossArray
{
    if (!_ossArray) {
        _ossArray = [NSMutableArray array];
    }
    
    return _ossArray;
}

-(void)setPageNum:(NSInteger)pageNum
{
    _pageNum = pageNum;
    
    self.recordImage.image = [UIImage imageNamed:@"kBook_record"];
    self.recordNum = 1;
    
    self.animationView.hidden = YES;
    
    [self leftAndRightButtonGray];
    
    NSInteger page = pageNum + 1;
    
    self.pageNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",page,self.totalPage];
    
    NSLog(@"pageNum ===> %ld",pageNum);
    
    self.lock = [[NSLock alloc] init];
}



-(void)setCurIndex:(NSInteger)curIndex
{
    if ([MusicPlayTool shareMusicPlay].player.rate > 0) {
       
        self.recordImage.image = [UIImage imageNamed:@"kBook_newRecord"];
        self.recordButton.userInteractionEnabled = YES;
        
        self.playImageView.image = [UIImage imageNamed:@"kBook_play"];
        self.leftLabel.text = @"播放";
        self.playButton.selected = NO;
        
        [[MusicPlayTool shareMusicPlay] musicPause];
        
        [self.animationView stop];
        [self deletePlayTimer];
    }
    
    _curIndex = curIndex;
    self.pageNum = curIndex;
    
    NSLog(@"self.pageNum===%ld",(long)self.pageNum);
    NSLog(@"curIndex===%ld",curIndex);
    
    
    if (self.dataArray.count >= curIndex) {
        
        KBookVoiceInfo *info = [self.dataArray objectAtIndex:curIndex];
        if (info.pageNum == 0) {
            self.textView.textAlignment = NSTextAlignmentCenter;
        }else{
            self.textView.textAlignment = NSTextAlignmentLeft;
        }
        [self.textView setContentOffset:CGPointZero];//让textView text每次从最顶部显示
        self.textView.showsVerticalScrollIndicator = NO;
        NSString *text = [info.content stringByReplacingOccurrencesOfString:@"。" withString:@"。\n"];
        self.textView.text = text;
        self.textView.text = info.content;
        self.textView.font = MY_FONT(16);
//        [self contentSizeToFit];
        
        NSString *localUrl = nil;
        for (NSDictionary *dic in self.mp3PathArray) {
            NSInteger sortNum = [[dic objectForKey:@"sortNum"] integerValue];
            NSString *mp3Path = [dic objectForKey:@"mp3Path"];
            if (sortNum == info.pageNum) {
                
                localUrl = mp3Path;
                break;
            }
        }
        
        if (localUrl != nil && localUrl.length > 0 ) {
            //本地有K语音
            self.recordImage.image = [UIImage imageNamed:@"kBook_newRecord"];
            self.animationView.hidden = NO;
            self.recordNum = ButtonClickNewRecord;
            
            //获取录音文件时长
            NSInteger duration = [self audioSoundDurationWithFilePath:localUrl];
            NSLog(@"本地文件录音时长:duration===>%ld",duration);
            
            NSInteger second = duration % 60;
            NSInteger minute = duration / 60;
            
            self.animationView.text = [NSString stringWithFormat:@"%02ld : %02ld",(long)minute,second];
            
            [self leftAndRightButtonNormal];
            
        }else{
            if ([info.status isEqualToString:@"1"] && info.kAudio != nil && info.kAudio.length) {
                //服务器有K语音
                self.recordImage.image = [UIImage imageNamed:@"kBook_newRecord"];
                self.animationView.hidden = NO;
                self.recordNum = ButtonClickNewRecord;
                
                //获取录音文件时长
                NSInteger duration = [self audioSoundDurationWithFilePath:info.kAudio];
                NSLog(@"服务器文件录音时长:duration===>%ld",duration);
                
                NSInteger second = duration % 60;
                NSInteger minute = duration / 60;
                
                self.animationView.text = [NSString stringWithFormat:@"%02ld : %02ld",(long)minute,second];
                
                [self leftAndRightButtonNormal];
            }
        }
    
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>) self;

    self.pageNum = 0;//默认从第一页开始
    self.recordNum = 1;//录音按钮状态
    
    self.recordDuration = 0;
    
    [self getKBookVoiceInfo:self.bookId];
    
    [self initView];
    self.curIndex = 0;
    [MusicPlayTool shareMusicPlay].delegat = self;
}

- (void)initView{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 73)];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomView_height, self.view.frame.size.width, bottomView_height)];
    [self.view addSubview:_bottomView];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height)];
    [_middleView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_middleView];
    
    [self createTopViewChild];
    [self createBottomViewChild];
    [self createMiddleViewChild];
}

-(void) createMiddleViewChild
{
    UIView *topMidView = [[UIView alloc] init];
    topMidView.frame = CGRectMake(0, 0, _middleView.frame.size.width, 240);
    [_middleView addSubview:topMidView];
    
    self.curIndex = 0;
    KBookCollectionLayout *layout = [[KBookCollectionLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.sectionInset = UIEdgeInsetsMake(0, (topMidView.frame.size.width - layout.itemSize.width)*0.5 - 10, 0, (topMidView.frame.size.width - layout.itemSize.width)*0.5 - 10);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, topMidView.frame.size.width, 230) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [topMidView addSubview:self.collectionView];
    
    UILabel *pageNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(-2, 14, 55, 30)];
    pageNumLabel.alpha = 0.5;
    pageNumLabel.backgroundColor = COLOR_STRING(@"#202020");
    pageNumLabel.textAlignment = NSTextAlignmentCenter;
    pageNumLabel.textColor = COLOR_STRING(@"#D3D3D3");
    pageNumLabel.font = MY_FONT(18);
    pageNumLabel.layer.cornerRadius = 4;
    pageNumLabel.layer.masksToBounds = YES;
    self.pageNumLabel = pageNumLabel;
    [_middleView addSubview:pageNumLabel];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(24, topMidView.frame.origin.y + topMidView.frame.size.height + 10, _middleView.frame.size.width - 24*2, _middleView.frame.size.height - topMidView.frame.origin.y - topMidView.frame.size.height - 10 - 20);
    textView.backgroundColor = [UIColor clearColor];
    textView.font = MY_FONT(16);
    textView.textColor = COLOR_STRING(@"#666666");
    textView.editable = NO;
    self.textView = textView;
    [_middleView addSubview:textView];
}

-(void) createBottomViewChild
{
    self.animationView = [[KBookRecordAnimationView alloc] initWithFrame:CGRectMake(CGRectGetMidX(_bottomView.bounds) - 180*0.5, 0, 180, 50.0)];
    self.animationView.middleInterval = 60;
    self.animationView.itemColor = COLOR_STRING(@"#FF721C");
    [_bottomView addSubview:self.animationView];
    
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake((self.bottomView.frame.size.width - 95)*0.5, bottomView_height - 95 - 20, 95, 95)];
    [self.recordButton addTarget:self action:@selector(recordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:self.recordButton];
    
    UIImageView *recordImage = [[UIImageView alloc]initWithFrame:self.recordButton.frame];
    [recordImage setImage:[UIImage imageNamed:@"kBook_record"]];//起始默认录音图标
    self.recordImage = recordImage;
    [_bottomView addSubview:recordImage];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake((self.bottomView.frame.size.width*0.5 - 60) * 0.5 - 15, bottomView_height - 20 - 50, 60, 50)];
    [leftView setBackgroundColor:[UIColor clearColor]];
    self.leftView = leftView;
    [_bottomView addSubview:leftView];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake((leftView.frame.size.width - 22)*0.5, 0, 22, 22)];
    [leftImageView setImage:[UIImage imageNamed:@"kBook_play"]];
    self.playImageView = leftImageView;
    [leftView addSubview:leftImageView];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, leftImageView.frame.origin.y + leftImageView.frame.size.height, leftView.frame.size.width, 20)];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.text = @"播放";
    leftLabel.textColor = COLOR_STRING(@"#909090");
    leftLabel.font = MY_FONT(13);
    self.leftLabel = leftLabel;
    [leftView addSubview:leftLabel];
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, leftView.frame.size.width, leftView.frame.size.height)];
    [playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.playButton = playButton;
    [leftView addSubview:playButton];
    
    UIView *nextView = [[UIView alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width*0.5 +(self.bottomView.frame.size.width*0.5 - 60)*0.5 + 15, bottomView_height - 20 - 50, 60, 50)];
    [nextView setBackgroundColor:[UIColor clearColor]];
    self.nextView = nextView;
    [_bottomView addSubview:nextView];
    
    UIImageView *nextImageview = [[UIImageView alloc] initWithFrame:CGRectMake((nextView.frame.size.width - 22)*0.5, 0, 22, 22)];
    [nextImageview setImage:[UIImage imageNamed:@"kBook_next"]];
    self.nextImageview = nextImageview;
    [nextView addSubview:nextImageview];
    
    UILabel *nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nextImageview.frame.origin.y + nextImageview.frame.size.height, nextView.frame.size.width, 20)];
    nextLabel.textAlignment = NSTextAlignmentCenter;
    nextLabel.text = @"下一页";
    nextLabel.textColor = COLOR_STRING(@"#909090");
    nextLabel.font = MY_FONT(13);
    self.nextLabel = nextLabel;
    [nextView addSubview:nextLabel];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, nextView.frame.size.width, nextView.frame.size.height)];
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton = nextButton;
    [nextView addSubview:nextButton];
    
    //覆盖在"下一个"button  上的
    UIView *finishView = [[UIView alloc] initWithFrame:nextView.frame];
    [finishView setBackgroundColor:[UIColor clearColor]];
    finishView.hidden = YES; //默认隐藏 --> 等最后一页完成后显示
    self.finishView = finishView;
    [_bottomView addSubview:finishView];
    
    UIImageView *finishImageview = [[UIImageView alloc] initWithFrame:nextImageview.frame];
    [finishImageview setImage:[UIImage imageNamed:@"kBook_finish"]];
    self.finishImgView = finishImageview;
    [finishView addSubview:finishImageview];
    
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:nextLabel.frame];
    finishLabel.textAlignment = NSTextAlignmentCenter;
    finishLabel.text = @"完成";
    finishLabel.textColor = COLOR_STRING(@"#909090");
    finishLabel.font = MY_FONT(13);
    self.finishLabel = finishLabel;
    [finishView addSubview:finishLabel];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = nextButton.frame;
    [finishButton addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.finishButton = finishButton;
    [finishView addSubview:finishButton];
}

-(void) createTopViewChild {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"K绘本";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}

-(void)KBookList:(UIButton *)sender
{
    KBookListViewController *listVC = [[KBookListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark - 播放相关
-(void)playButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    KBookVoiceInfo *info = [self.dataArray objectAtIndex:self.pageNum];
    
    if (sender.selected == YES) {
        
        //录音按钮不可点击
        self.recordImage.image = [UIImage imageNamed:@"kBook_newRecord_H"];
        self.recordButton.userInteractionEnabled = NO;
        
        self.playImageView.image = [UIImage imageNamed:@"kBook_playStop"];
        self.leftLabel.text = @"暂停";
        
        if (self.mp3PathArray.count != 0) {
            
            NSString *localUrl = nil;
            for (NSDictionary *dic in self.mp3PathArray) {
                NSInteger sortNum = [[dic objectForKey:@"sortNum"] integerValue];
                NSString *mp3Path = [dic objectForKey:@"mp3Path"];
                if (sortNum == info.pageNum) {
                    localUrl = mp3Path;
                    NSLog(@"localUrl ===> %@",localUrl);
                    NSLog(@"mp3Path====>%@",mp3Path);
                    
                    break;
                }
            }
            
            if (localUrl == nil) {
                //当前页没有本地录音
                if(info.kAudio.length > 0){
                    //服务器有录音
                    [MusicPlayTool shareMusicPlay].urlString = info.kAudio;
                    [[MusicPlayTool shareMusicPlay] musicPrePlay];
                }
            }else{
                //当前页有本地录音
                if (localUrl.length > 0) {
                    [MusicPlayTool shareMusicPlay].urlString = localUrl;
                    [[MusicPlayTool shareMusicPlay] musicPrePlay];
                }
            }
            
        }else if (info.kAudio.length > 0){
            
            [MusicPlayTool shareMusicPlay].urlString = info.kAudio;
            [[MusicPlayTool shareMusicPlay] musicPrePlay];
        }
        
        [self deletePlayTimer];
        [self showPlayTime];
        
        //监听 播放结束,自动改变按钮的状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[MusicPlayTool shareMusicPlay].player.currentItem];
    }else{
        
        self.recordImage.image = [UIImage imageNamed:@"kBook_newRecord"];
        self.recordButton.userInteractionEnabled = YES;
        
        self.playImageView.image = [UIImage imageNamed:@"kBook_play"];
        self.leftLabel.text = @"播放";
        
        [[MusicPlayTool shareMusicPlay] musicPause];
        [[MusicPlayTool shareMusicPlay] removeObserverStatus];
        [[MusicPlayTool shareMusicPlay].player replaceCurrentItemWithPlayerItem:nil];
        
        [self.animationView stop];
//        [self deleteTimer];
        [self deletePlayTimer];
    }
}

-(void)playFinished:(NSNotification *)noti
{
    NSLog(@"播放结束");
    
    self.recordImage.image = [UIImage imageNamed:@"kBook_newRecord"];
    self.recordButton.userInteractionEnabled = YES;
    
    self.playImageView.image = [UIImage imageNamed:@"kBook_play"];
    self.leftLabel.text = @"播放";
    self.playButton.selected = NO;
    
    [self.animationView stop];
    [self deletePlayTimer];
}
-(void)startRecordAnimation
{
    [self startRecordAnimation:YES];
}
-(void)startRecordAnimation:(BOOL) isSettingDelegate
{
    //关掉喜马拉雅播放器
    if ([XYDMSetting IsPlaying]) {
        [XYDMSetting pause];
    }
    [self setAudioSession];
    //创建录音文件保存路径
        //1.获取服务器返回的sortNum
    KBookVoiceInfo *voiceInfo = nil;
    if (self.dataArray.count) {
        voiceInfo = [self.dataArray objectAtIndex:self.pageNum];
    }
    NSURL *url = [self getSavePathWithBookID:self.bookId WithPage:voiceInfo.pageNum];
    //创建录音格式设置
    NSDictionary *setting = [self getAudioSetting];
    //创建录音机
    NSError *error = nil;
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
    if (isSettingDelegate) {
        recorder.delegate = self;
        recorder.meteringEnabled = YES;//如果要监控声波则必须设置为YES
    }
    
    
    if (error) {
        NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
    }
    
    __weak KBookRecordAnimationView *weakAnimationView = self.animationView;
    self.animationView.itemLevelCallback = ^() {
        
        [recorder updateMeters];
        
        //取得第一个通道的音频，音频强度范围是-160到0
        float power= [recorder averagePowerForChannel:0];
        weakAnimationView.level = power;
    };
    
    [recorder record];
    self.recorder = recorder;
    [self.animationView start];
    
    if (isSettingDelegate) {
        self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateRecordTime) userInfo:nil repeats:YES];
    }
    
    
}

-(void)updateRecordTime
{
    self.recordDuration++;
    NSLog(@"====> updateRecordTime <==== %li",(long)self.recordDuration);
    if (self.recordDuration >= Recording_Time) {
        //自动停止录音
        [self newRecordStop];
        self.collectionView.userInteractionEnabled = YES;
        [self leftAndRightButtonNormal];
        
        //按钮点击+1
        self.recordNum++;
    }
}


-(void)showRecordTime
{
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTextLabel) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}

-(void)updateTextLabel
{
    NSLog(@"recorder.currentTime====>%f",self.recorder.currentTime);
    NSInteger time = self.recorder.currentTime;
    NSInteger second = time % 60;
    NSInteger minute = time / 60;
    self.animationView.text = [NSString stringWithFormat:@"%02ld : %02ld",(long)minute,second];
}



-(void)showPlayTime
{
    self.playTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updatePlayLabel) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.playTimer forMode:NSDefaultRunLoopMode];
    [self.playTimer fire];
}

-(void)updatePlayLabel
{
    CMTime currentTime = [MusicPlayTool shareMusicPlay].player.currentTime;
    
    NSInteger time = CMTimeGetSeconds(currentTime);
    NSInteger second = time % 60;
    NSInteger minute = time / 60;
    self.animationView.text = [NSString stringWithFormat:@"%02ld : %02ld",(long)minute,second];
}

-(void)deleteTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)deletePlayTimer
{
    [self.playTimer invalidate];
    self.playTimer = nil;
}

-(void)stopRecordAnimation
{
    [self.recorder stop];
    self.recorder = nil;
    [self.animationView stop];
}

#pragma mark - MusicPlayToolDelegate
-(void)endOfPlayAction
{
    [self playFinished:nil];
}

//下一页
-(void)nextButtonClick:(UIButton *)sender
{
    if (self.pageNum < self.totalPage) {
        self.pageNum++;
    }
    
    //图片跟着右滑
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageNum inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.curIndex = self.pageNum;
}

//完成
-(void)finishButtonClick:(id)sender
{
    NSLog(@"====> finishButtonClick <====  %i",self.retainCountForThread);
    [MBProgressHUD hideHUD];
    if(self.retainCountForThread == 0){
        
        
        if (self.mp3PathArray.count <= 0) {
            [MBProgressHUD showText:@"请录音后上传文件"];
            NSLog(@"请录音后上传文件");
            return;
        }
        
        NSArray *array = [self checkRecordFileList];
        
//        array = [self compareDataArray:self.dataArray setCompareArray:array];
        NSLog(@"service record array ===> %@",self.dataArray);
        NSLog(@"unRecord array ===> %@",array);
        if (array.count > 3) {
            
            [self showAlertWithType:Alert_Service WithTitle:@"当前绘本还有部分未录制"];
            
        }else{
            if(array.count == 0){
                [self uploadOssService];
            } else {
                [self showAlertWithType:Alert_Service WithTitle:@""];
            }
//            if (self.totalPage == self.mp3PathArray.count) {
//                [self uploadOssService];
//            }else{
//                [self showAlertWithType:Alert_Service WithTitle:@""];
//            }
        }
    } else {
        [MBProgressHUD showMessage:@"处理中..."];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(finishButtonClick:) userInfo:nil repeats:NO];
    }
    
    
}

-(IBAction)backButtonClick:(id)sender
{
    //检查是否有录音,有就提示
    if (self.mp3PathArray.count > 0) {
        [self showAlertWithType:Alert_Quit WithTitle:@""];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)showAlertView
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"麦克风权限未开启" message:@"麦克风权限未开启,请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        sender.userInteractionEnabled = NO;
        return ;
    }];
    
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)showTipAlert
{
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:@"您未开启麦克风不能进行录音操作" message:@"请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        sender.userInteractionEnabled = NO;
        return ;
    }];
    [tipAlert addAction:cancelAction];
    [self presentViewController:tipAlert animated:YES completion:nil];
}

#pragma mark - 上传文件到oss服务器
-(void)uploadOssService
{
    [MBProgressHUD showMessage:@"保存中..."];
    
    //上传oss服务器
    for (NSDictionary *dic in self.mp3PathArray) {
        NSString *mp3Path = [dic objectForKey:@"mp3Path"];
        NSInteger sortNum = [[dic objectForKey:@"sortNum"] integerValue];
        
        [self uploadFileToServiceWithPath:mp3Path WithPage:sortNum];
    }
}

-(void)uploadFileToServiceWithPath:(NSString *)path WithPage:(NSInteger)sortNum
{
    __weak typeof(self) weakSelf = self;
    [JDOSSUploadfileHandle uploadKbookFile:path Callback:^(NSString * _Nonnull ossAdress) {
        NSLog(@"===>%@",ossAdress);
        if (ossAdress && ossAdress.length>1) {
            [weakSelf.lock lock];
            
            NSDictionary *ossDic = @{@"ossUrl":ossAdress,@"ossPage":[NSNumber numberWithInteger:sortNum]};
            [self.ossArray addObject:ossDic];
            
            if (weakSelf.ossArray.count == self.mp3PathArray.count) {
                //上传后台服务器
                [self KbookVoiceAddService];
            }
            
            [weakSelf.lock unlock];
        }else
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showText:@"上传异常，请重试"];
        }
    }];
//    void(^OnSuccess) (id,NSString *) = ^(id htttpInterface,NSString *description){
//        NSLog(@"KbookUplxfoadService ===> OnSuccess");
//        KbookUploadService *service = (KbookUploadService *)htttpInterface;
//        NSString *ossString = service.ossUrl;
//
//        NSLog(@"ossString===>%@",service.ossUrl);
//        [self.lock lock];
//
//        NSDictionary *ossDic = @{@"ossUrl":ossString,@"ossPage":[NSNumber numberWithInteger:sortNum]};
//        [self.ossArray addObject:ossDic];
//
//        if (self.ossArray.count == self.mp3PathArray.count) {
//            //上传后台服务器
//            [self KbookVoiceAddService];
//        }
//
//        [self.lock unlock];
//    };
//
//    void(^OnError)(NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
//        NSLog(@"KbookUploadService ===> OnError");
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showText:@"上传异常，请重试"];
//    };
//
//    NSLog(@"上传mp3文件路径:%@",path);
//
//    KbookUploadService *uploadService = [[KbookUploadService alloc] initWithPath:path BookId:self.bookId UserId:APP_DELEGATE.mLoginResult.userId setOnSuccess:OnSuccess setOnError:OnError];
//    [uploadService start];
}

-(void)KbookVoiceAddService
{
    void(^OnSuccess) (id,NSString *) = ^(id htttpInterface,NSString *description){
        NSLog(@"KbookVoiceAddService ===> OnSuccess");
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"保存成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    };
    
    void(^OnError)(NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"KbookVoiceAddService ===> OnError");
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:@"保存异常，请重试"];
    };
    
    NSMutableArray *mutableAarray = [NSMutableArray array];
    NSMutableArray *paraMutableArray = [NSMutableArray array];
    
    for (KBookVoiceInfo *info in self.dataArray) {
        if (info.kAudio.length > 0) {
            [mutableAarray addObject:[NSNumber numberWithInteger:info.pageNum]];
            
            BOOL samPage = NO;
            
            //如果oss里面存在一样的pageNum 不能加入
            for (NSDictionary *ossDic in self.ossArray) {
                NSInteger ossPage = [[ossDic objectForKey:@"ossPage"] integerValue];
                
                if (info.pageNum == ossPage) {
                    samPage = YES;
                    break;
                }
            }
            
            if (samPage == NO) {
                NSDictionary *dic = @{@"sortNum":[NSNumber numberWithInteger:info.pageNum],@"status":@"1",@"voiceUrl":info.kAudio};
                [paraMutableArray addObject:dic];
            }
        }
    }
    
    for (NSDictionary *ossDic in self.ossArray) {
        NSInteger ossPage = [[ossDic objectForKey:@"ossPage"] integerValue];
        NSString *ossUrl = [ossDic objectForKey:@"ossUrl"];
        [mutableAarray addObject:[NSNumber numberWithInteger:ossPage]];
        
        NSDictionary *dic = @{@"sortNum":[NSNumber numberWithInteger:ossPage],@"status":@"1",@"voiceUrl":ossUrl};
        [paraMutableArray addObject:dic];
    }
    
    NSLog(@"对比前mutableAarray===>%@",mutableAarray);
    
    NSArray *noKaudioArray = [self CompareDifferentData:self.totalArray WithArray:mutableAarray];
    if (noKaudioArray.count > 0) {
        for (NSNumber *sortNum in noKaudioArray) {
            NSDictionary *paraDic = @{@"sortNum":sortNum,@"status":@"0",@"voiceUrl":@""};
            [paraMutableArray addObject:paraDic];
        }
    }
    
    NSDictionary *paramesDic = @{@"uploadKBookList":paraMutableArray};
    NSLog(@"uploadKBookList-->%@",paraMutableArray);

    KbookVoiceAddService *addService = [[KbookVoiceAddService alloc] initWithOnSuccess:OnSuccess setOnError:OnError setToken:APP_DELEGATE.mLoginResult.token setDictionary:paramesDic setBookId:self.bookId];
    [addService start];
}

#pragma mark - 网络请求
-(void)getKBookVoiceInfo:(NSString *)bookId
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        NSLog(@"KBookVoiceService ==> OnSuccess");
        
        KBookVoiceService *kbookService = (KBookVoiceService *)httpInterface;
        NSArray *array = kbookService.kbookArray;
        self.totalPage = kbookService.kbookArray.count;
        self.dataArray = [NSArray arrayWithArray:array];
        
        NSMutableArray *totalMutableArray = [NSMutableArray array];
        //total 加入后台返回的sortNum
        for (KBookVoiceInfo *voiceInfo in self.dataArray) {
            if (voiceInfo != nil) {
                NSInteger sortNum = voiceInfo.pageNum;
                [totalMutableArray addObject:[NSNumber numberWithInteger:sortNum]];
            }
        }
        self.totalArray = [NSArray arrayWithArray:totalMutableArray];
        
        KBookVoiceInfo *info = [array firstObject];
        if (info.pageNum == 0) {
            self.textView.textAlignment = NSTextAlignmentCenter;
            self.pageNumLabel.text = [NSString stringWithFormat:@"%d/%ld",1,self.totalPage];
            
            if ([info.status isEqualToString:@"1"] && info.kAudio != nil && info.kAudio.length) {
                //有k语音记录
                self.recordImage.image = [UIImage imageNamed:@"kBook_newRecord"];
                self.leftView.hidden = NO;
                self.nextView.hidden = NO;
                self.animationView.hidden = NO;
                self.recordNum = ButtonClickNewRecord;
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        //获取录音文件时长
                        NSInteger duration = [self audioSoundDurationWithFilePath:info.kAudio];
                        NSLog(@"文件录音时长:duration===>%ld",duration);
                        
                        NSInteger second = duration % 60;
                        NSInteger minute = duration / 60;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.animationView.text = [NSString stringWithFormat:@"%02ld : %02ld",(long)minute,second];
                        });
                    });
                
                [self leftAndRightButtonNormal];
            }
        }else{
            self.textView.textAlignment = NSTextAlignmentLeft;
        }
        NSString *text = [info.content stringByReplacingOccurrencesOfString:@"。" withString:@"。\r"];
        self.textView.text = text;
        self.textView.text = info.content;
        [self contentSizeToFit];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
        });
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"KBookVoiceService ==> OnError");
    };
    
    KBookVoiceService *service = [[KBookVoiceService alloc] init:OnSuccess setOnError:OnError setBookId:bookId setToken:APP_DELEGATE.mLoginResult.token];
    [service start];
}

//暂时没有用到此接口
-(void)getKbookContentByPageNum:(NSInteger )pageNum
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        NSLog(@"KBookPageService ==> OnSuccess");
        
        KBookPageService *pageService = (KBookPageService *)httpInterface;
        NSLog(@"pageService === > %@",pageService);
        NSLog(@"pageService.bookPageObject.content =====> %@",pageService.bookPageObject.content);

    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"KBookPageService ==> OnError");
    };
    
    KBookPageService *service = [[KBookPageService alloc]init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setBookId:[self.bookId integerValue] setPageNum:pageNum setGroupId:0];
    [service start];
}

#pragma mark - 提示框
-(void) showAlertWithType:(AlertType )type WithTitle:(NSString *)title
{
    UIView *alertMaskView = [[UIView alloc] initWithFrame:self.view.bounds];
    alertMaskView.backgroundColor = [UIColor colorWithHexStr:@"#202020" alpha:0.7];
    self.alertMaskView = alertMaskView;
    [self.view addSubview:alertMaskView];
    
    UIView *recordAlertView = [[UIView alloc] initWithFrame:CGRectMake(36, (alertMaskView.frame.size.height - 183)*0.5, alertMaskView.frame.size.width - 36*2, 183)];
    recordAlertView.backgroundColor = COLOR_STRING(@"#F6F6F6");
    recordAlertView.layer.cornerRadius = 8;
    recordAlertView.layer.masksToBounds = YES;
    self.recordAlertView = recordAlertView;
    [alertMaskView addSubview:recordAlertView];
    
    UIView *serviceAlertView = [[UIView alloc] initWithFrame:CGRectMake(36, (alertMaskView.frame.size.height - 143)*0.5 - 58*0.5, alertMaskView.frame.size.width - 36*2, 143)];
    serviceAlertView.backgroundColor = COLOR_STRING(@"#F6F6F6");
    serviceAlertView.layer.cornerRadius = 8;
    serviceAlertView.layer.masksToBounds = YES;
    self.serviceAlertView = serviceAlertView;
    [alertMaskView addSubview:serviceAlertView];
    
    UIView *quitAlertView = [[UIView alloc] initWithFrame:CGRectMake(36, (alertMaskView.frame.size.height - 183)*0.5, alertMaskView.frame.size.width - 36*2, 183)];
    quitAlertView.backgroundColor = COLOR_STRING(@"#F6F6F6");
    quitAlertView.layer.cornerRadius = 8;
    quitAlertView.layer.masksToBounds = YES;
    self.quitAlertView = quitAlertView;
    [alertMaskView addSubview:quitAlertView];
    
    if (type == Alert_Record) {
        
        recordAlertView.hidden = NO;
        serviceAlertView.hidden = YES;
        quitAlertView.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((recordAlertView.frame.size.width - 32)*0.5, 30, 32, 32)];
        imageView.image = [UIImage imageNamed:@"kBook_alert"];
        [recordAlertView addSubview:imageView];
        
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height + 10, recordAlertView.frame.size.width, 15)];
        content.textAlignment = NSTextAlignmentCenter;
        content.textColor = COLOR_STRING(@"#9B9B9B");
        content.font = MY_FONT(14);
        content.text = @"本页已经有配音了,确定要重新录制吗?";
        [recordAlertView addSubview:content];
        
        UIButton *noTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        noTipButton.frame = CGRectMake((recordAlertView.frame.size.width - 80)*0.5, content.frame.origin.y + content.frame.size.height, 80, 30);
        [noTipButton addTarget:self action:@selector(clickNoTip:) forControlEvents:UIControlEventTouchUpInside];
        self.noTipButton = noTipButton;
        [recordAlertView addSubview:noTipButton];
        
        UIImageView *noTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(recordAlertView.frame.size.width*0.5 - 27 - 15, content.frame.origin.y + content.frame.size.height + 10, 15, 15)];
        noTipImageView.image = [UIImage imageNamed:@"kBook_notip"];
        self.noTipImageView = noTipImageView;
        [recordAlertView addSubview:noTipImageView];
        
        UILabel *noTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(noTipImageView.frame.origin.x + noTipImageView.frame.size.width + 8, content.frame.origin.y + content.frame.size.height + 10, 100, 15)];
        noTipLabel.textColor = COLOR_STRING(@"#9B9B9B");
        noTipLabel.font = MY_FONT(14);
        noTipLabel.text = @"不再提示";
        [recordAlertView addSubview:noTipLabel];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, recordAlertView.frame.size.height - 42, (recordAlertView.frame.size.width - 1)*0.5, 42);
        [cancelButton setTitle:@"取消录制" forState:UIControlStateNormal];
        [cancelButton setTitleColor:COLOR_STRING(@"#666666") forState:UIControlStateNormal];
        cancelButton.titleLabel.font = MY_FONT(18);
        [cancelButton setBackgroundColor:COLOR_STRING(@"#E5E5E5")];
        [cancelButton addTarget:self action:@selector(clickRecordAlertCancel:) forControlEvents:UIControlEventTouchUpInside];
        [recordAlertView addSubview:cancelButton];
        
        UIView *vertLine = [[UIView alloc] initWithFrame:CGRectMake((recordAlertView.frame.size.width - 1)*0.5, recordAlertView.frame.size.height - 42, 1, 42)];
        vertLine.backgroundColor = [UIColor whiteColor];
        [recordAlertView addSubview:vertLine];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(vertLine.frame.origin.x + vertLine.frame.size.width, cancelButton.frame.origin.y, recordAlertView.frame.size.width - vertLine.frame.origin.x - vertLine.frame.size.width, 42);
        [sureButton setTitle:@"重新录制" forState:UIControlStateNormal];
        [sureButton setTitleColor:COLOR_STRING(@"#666666") forState:UIControlStateNormal];
        sureButton.titleLabel.font = MY_FONT(18);
        sureButton.backgroundColor = COLOR_STRING(@"#E5E5E5");
        [sureButton addTarget:self action:@selector(clickRecordAlertSure:) forControlEvents:UIControlEventTouchUpInside];
        [recordAlertView addSubview:sureButton];
        
        if ([title isEqualToString:@"kBook_recordStop"]) {
            sureButton.tag = 30;
        }
        
    }else if (type == Alert_Service){
        
        recordAlertView.hidden = YES;
        serviceAlertView.hidden = NO;
        quitAlertView.hidden = YES;
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, serviceAlertView.frame.size.width, 20)];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"提示";
        tipLabel.textColor = COLOR_STRING(@"#666666");
        tipLabel.font = MY_FONT(18);
        [serviceAlertView addSubview:tipLabel];
        
        UILabel *pageTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tipLabel.frame.origin.y + tipLabel.frame.size.height + 12, serviceAlertView.frame.size.width, 20)];
        pageTipLabel.textAlignment = NSTextAlignmentCenter;
        pageTipLabel.textColor = COLOR_STRING(@"#9B9B9B");
        pageTipLabel.font = MY_FONT(16);
        [serviceAlertView addSubview:pageTipLabel];
        
        if (title.length > 0) {
            pageTipLabel.text = title;
        }else{
            NSArray *array = [self checkRecordFileList];
//            array = [self compareDataArray:self.dataArray setCompareArray:array];
            if (array.count == 1) {
                NSInteger page = [[array firstObject] integerValue];
                pageTipLabel.text = [NSString stringWithFormat:@"当前绘本还有第%ld页还未录制",page+1];
            }else if (array.count == 2){
                NSInteger firstPage = [[array firstObject] integerValue];
                NSInteger lastPage = [[array lastObject] integerValue];
                pageTipLabel.text = [NSString stringWithFormat:@"当前绘本还有第%ld、%ld页还未录制",firstPage+1,lastPage+1];
            }else if (array.count == 3){
                NSInteger firstPage = [[array firstObject] integerValue];
                NSInteger middlePage = [[array objectAtIndex:1] integerValue];
                NSInteger lastPage = [[array lastObject] integerValue];
                
                pageTipLabel.text = [NSString stringWithFormat:@"当前绘本还有第%ld、%ld、%ld页还未录制",firstPage+1,middlePage+1,lastPage+1];
            }
        }
        
        UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        recordButton.frame = CGRectMake(0, serviceAlertView.frame.size.height - 42, (serviceAlertView.frame.size.width - 1)*0.5, 42);
        [recordButton setTitle:@"继续录制" forState:UIControlStateNormal];
        [recordButton setTitleColor:COLOR_STRING(@"#666666") forState:UIControlStateNormal];
        recordButton.titleLabel.font = MY_FONT(18);
        [recordButton setBackgroundColor:COLOR_STRING(@"#E5E5E5")];
        [recordButton addTarget:self action:@selector(clickServiceRecord:) forControlEvents:UIControlEventTouchUpInside];
        [serviceAlertView addSubview:recordButton];
        
        UIView *vertLine = [[UIView alloc] initWithFrame:CGRectMake((serviceAlertView.frame.size.width - 1)*0.5, serviceAlertView.frame.size.height - 42, 1, 42)];
        vertLine.backgroundColor = [UIColor whiteColor];
        [serviceAlertView addSubview:vertLine];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.frame = CGRectMake(vertLine.frame.origin.x + vertLine.frame.size.width, recordButton.frame.origin.y, serviceAlertView.frame.size.width - vertLine.frame.origin.x - vertLine.frame.size.width, 42);
        [saveButton setTitle:@"保存录音" forState:UIControlStateNormal];
        [saveButton setTitleColor:COLOR_STRING(@"#666666") forState:UIControlStateNormal];
        saveButton.titleLabel.font = MY_FONT(18);
        saveButton.backgroundColor = COLOR_STRING(@"#E5E5E5");
        [saveButton addTarget:self action:@selector(clickServiceSave:) forControlEvents:UIControlEventTouchUpInside];
        [serviceAlertView addSubview:saveButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake((alertMaskView.frame.size.width - 27)*0.5, serviceAlertView.frame.origin.y + serviceAlertView.frame.size.height + 19, 27, 27);
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"kBook_ServieAlertCancel"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(clickServiceCancel:) forControlEvents:UIControlEventTouchUpInside];
        [alertMaskView addSubview:cancelButton];
        
    }else if (type == Alert_Quit){
        recordAlertView.hidden = YES;
        serviceAlertView.hidden = YES;
        quitAlertView.hidden = NO;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((quitAlertView.frame.size.width - 32)*0.5, 30, 32, 32)];
        imageView.image = [UIImage imageNamed:@"kBook_alert"];
        [quitAlertView addSubview:imageView];
        
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height + 10, quitAlertView.frame.size.width, 15)];
        content.textAlignment = NSTextAlignmentCenter;
        content.textColor = COLOR_STRING(@"#9B9B9B");
        content.font = MY_FONT(14);
        content.text = @"当前绘本还未录制完成,";
        [quitAlertView addSubview:content];
        
        UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, content.frame.origin.y + content.frame.size.height + 9, quitAlertView.frame.size.width, 15)];
        downLabel.textAlignment = NSTextAlignmentCenter;
        downLabel.textColor = COLOR_STRING(@"#9B9B9B");
        downLabel.font = MY_FONT(14);
        downLabel.text = @"是否退出?";
        [quitAlertView addSubview:downLabel];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, quitAlertView.frame.size.height - 42, (quitAlertView.frame.size.width - 1)*0.5, 42);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:COLOR_STRING(@"#666666") forState:UIControlStateNormal];
        cancelButton.titleLabel.font = MY_FONT(18);
        [cancelButton setBackgroundColor:COLOR_STRING(@"#E5E5E5")];
        [cancelButton addTarget:self action:@selector(clickQuitAlertViewCancel:) forControlEvents:UIControlEventTouchUpInside];
        [quitAlertView addSubview:cancelButton];
        
        UIView *vertLine = [[UIView alloc] initWithFrame:CGRectMake((quitAlertView.frame.size.width - 1)*0.5, quitAlertView.frame.size.height - 42, 1, 42)];
        vertLine.backgroundColor = [UIColor whiteColor];
        [quitAlertView addSubview:vertLine];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(vertLine.frame.origin.x + vertLine.frame.size.width, cancelButton.frame.origin.y, quitAlertView.frame.size.width - vertLine.frame.origin.x - vertLine.frame.size.width, 42);
        [sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [sureButton setTitleColor:COLOR_STRING(@"#666666") forState:UIControlStateNormal];
        sureButton.titleLabel.font = MY_FONT(18);
        sureButton.backgroundColor = COLOR_STRING(@"#E5E5E5");
        [sureButton addTarget:self action:@selector(clickQuitAlertViewSure:) forControlEvents:UIControlEventTouchUpInside];
        [quitAlertView addSubview:sureButton];
    }
}

//不再提示
-(void)clickNoTip:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.noTipImageView.image = [UIImage imageNamed:@"kBook_notipSelected"];
    }else{
        self.noTipImageView.image = [UIImage imageNamed:@"kBook_notip"];
    }
}

-(void)clickRecordAlertCancel:(UIButton *)sender
{
    self.alertMaskView.hidden = YES;
    self.recordNum--;
}

-(void)clickRecordAlertSure:(UIButton *)sender
{
    self.alertMaskView.hidden = YES;
    
    if (sender.tag == 30) {//重新录制
        
        [self newRecordStart];
    }
}

-(void)clickServiceCancel:(UIButton *)sender
{
    self.alertMaskView.hidden = YES;
}

//保存录音--上传服务器
-(void)clickServiceSave:(UIButton *)sender
{
    self.alertMaskView.hidden = YES;
    
    [self uploadOssService];
}

//继续录制
-(void)clickServiceRecord:(UIButton *)sender
{
    self.alertMaskView.hidden = YES;
    
    [self scrollerToNotRecordPage];
}

-(void)clickQuitAlertViewCancel:(UIButton *)sender
{
    self.alertMaskView.hidden = YES;
}

-(void)clickQuitAlertViewSure:(UIButton *)sender
{
    self.alertMaskView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
    //是否保存录音,暂未确定
}

//滚动到未录制的首页
-(void)scrollerToNotRecordPage
{
    NSArray *pageArray = [self checkRecordFileList];
    NSInteger page = [[pageArray firstObject] integerValue];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.curIndex = page;
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    KBookVoiceInfo *info = self.dataArray[indexPath.row];
    NSLog(@"info.pic--->%@",info.pic);
    UIImageView *imgView = [[UIImageView alloc] init];
    if (info != nil && info.pic.length > 0) {
        
        NSString *url = [self disposeImageWithUrl:info.pic WithParameter:@"m_pad,h_600,w_750"];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@""]];
    }else{
        imgView.image = [UIImage imageNamed:@""];
    }
    
    cell.backgroundView = imgView;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果点击是 当前显示的cell 返回
    if (indexPath.row == self.curIndex) {
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.curIndex = indexPath.row;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        
        NSInteger scrIndex = scrollView.contentOffset.x / (ITEM_WIDTH + 10);
        
        
        NSLog(@"decelerate scrIndex===>%ld",(long)scrIndex);
        NSLog(@"decelerate self.curIndex ===> %ld",(long)self.curIndex);
        
        //判断是否在播放
        if ([MusicPlayTool shareMusicPlay].player.rate != 0) {
            
            if (self.curIndex == scrIndex + 1) {
                return;
            }
        }
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:scrIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        self.curIndex = scrIndex + 1;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger scrIndex = scrollView.contentOffset.x / (ITEM_WIDTH + 10);
    
    NSLog(@"EndDecelerating scrIndex===>%ld",scrIndex);
    NSLog(@"EndDecelerating self.curIndex ===> %ld",self.curIndex);
    
    
    //判断是否在播放
    if ([MusicPlayTool shareMusicPlay].player.rate != 0) {
        
        if (self.curIndex == scrIndex + 1) {
            return;
        }
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:scrIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.curIndex = scrIndex + 1;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
    
    [self startRecordAnimation:NO];
    self.animationView.hidden = NO;
    [self stopRecordAnimation];
    [self deleteTimer];
    
    self.retainCountForThread = 0;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
    
    [[MusicPlayTool shareMusicPlay] musicPause];
    [[MusicPlayTool shareMusicPlay] removeObserverStatus];
    [[MusicPlayTool shareMusicPlay].player replaceCurrentItemWithPlayerItem:nil];
    [MusicPlayTool shareMusicPlay].delegat = nil;
    
    self.retainCountForThread = 0;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)showBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)hideBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 清除录音缓存文件
-(void)deleteVoiceCache
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *voicePath = [NSString stringWithFormat:@"%@/voice",path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:voicePath]) {
        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:voicePath];
        for (NSString *fileName in enumerator) {
            
            [fileManager removeItemAtPath:[voicePath stringByAppendingPathComponent:fileName] error:nil];
        }
    }
}

- (void)contentSizeToFit
{
    //先判断一下有没有文字（没文字就没必要设置居中了）
    if([self.textView.text length]>0)
    {
        //textView的contentSize属性
        CGSize contentSize = self.textView.contentSize;
        //textView的内边距属性
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        
        //如果文字内容高度没有超过textView的高度
        if(contentSize.height <= self.textView.frame.size.height)
        {
            //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
            CGFloat offsetY = (self.textView.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
        else          //如果文字高度超出textView的高度
        {
            newSize = self.textView.frame.size;
            offset = UIEdgeInsetsZero;
            CGFloat fontSize = 18;
            
            //通过一个while循环，设置textView的文字大小，使内容不超过整个textView的高度（这个根据需要可以自己设置）
            while (contentSize.height > self.textView.frame.size.height)
            {
                [self.textView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                contentSize = self.textView.contentSize;
            }
            newSize = contentSize;
        }
        //根据前面计算设置textView的ContentSize和Y方向偏移量
        [self.textView setContentSize:newSize];
        [self.textView setContentInset:offset];
    }
}

#pragma mark - 录音相关
//录音
-(void)recordButtonClick:(UIButton *)sender
{
    if (self.dataArray.count == 0) {//录音判空保护.
        return;
    }
    //授权
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioAuthStatus == AVAuthorizationStatusNotDetermined)
    {
        //第一次询问
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted){
            if (granted) {
                //同意授权,进行录音操作
                self.recordNum++;
            }else{
                //不同意授权,提示用户
                [self showTipAlert];
                return ;
            }
        }];
    }else if(audioAuthStatus == AVAuthorizationStatusRestricted || audioAuthStatus == AVAuthorizationStatusDenied ){
        //未授权
        [self showAlertView];
        return;
    }else{
        //已授权
        self.recordNum++;
    }
    
    
    if (self.recordNum > 4) {
        self.recordNum = 3;
    }
    
    if (self.recordNum == ButtonClickRecordStart) {
        self.recordImage.image = [UIImage imageNamed:@"kBook_record"];
        
        NSLog(@"重录结束");
        self.animationView.hidden = NO;
        [self stopRecordAnimation];
        [self deleteTimer];
        
    }else if (self.recordNum == ButtonClickRecordStop){
        self.recordImage.image = [UIImage imageNamed:@"kBook_recordStop"];
        NSLog(@"开始录音");
        self.animationView.hidden = NO;
        [self startRecordAnimation];
        
        [self deletePlayTimer];
        [self showRecordTime];
        
        self.collectionView.userInteractionEnabled = NO;
        [self leftAndRightButtonGray];
        
    }else if (self.recordNum == ButtonClickNewRecord){
        
        NSLog(@"停止录音");
        
        [self newRecordStop];
        self.collectionView.userInteractionEnabled = YES;
        [self leftAndRightButtonNormal];
        
    }else if (self.recordNum == ButtonClickNewRecordStop){
        
        NSLog(@"开始重新录制");
        
        if (self.noTipButton.selected == YES) {
            
            [self newRecordStart];
        }else{
            [self showAlertWithType:Alert_Record WithTitle:@"kBook_recordStop"];
        }
    }
    
}

//重新录制
-(void)newRecordStart
{
    self.recordImage.image = [UIImage imageNamed:@"kBook_newRecordStop"];
    // 按钮变灰色,不可点击
    [self leftAndRightButtonGray];
    self.collectionView.userInteractionEnabled = NO;
    
    self.animationView.hidden = NO;
    [self startRecordAnimation];
    [self deletePlayTimer];
    [self showRecordTime];
}

-(void)newRecordStop
{
    self.recordImage.image = [UIImage imageNamed:@"kBook_newRecord"];
    [self leftAndRightButtonNormal];
    
    self.animationView.hidden = NO;
    [self stopRecordAnimation];
    [self deleteTimer];
}

//播放 下一页按钮 正常显示
-(void)leftAndRightButtonNormal
{
    self.playImageView.image = [UIImage imageNamed:@"kBook_play"];
    self.playButton.userInteractionEnabled = YES;
    self.leftLabel.textColor = [UIColor colorWithHexStr:@"#909090" alpha:1.0];
    
    if (self.pageNum == self.totalPage - 1) {
        self.nextView.hidden = YES;
        self.finishView.hidden = NO;
        
        self.finishImgView.image = [UIImage imageNamed:@"kBook_finish"];
        self.finishButton.userInteractionEnabled = YES;
        self.finishLabel.textColor = [UIColor colorWithHexStr:@"#FF5001" alpha:1.0];
        
    }else{
        self.nextView.hidden = NO;
        self.finishView.hidden = YES;
        
        self.nextImageview.image = [UIImage imageNamed:@"kBook_next"];
        self.nextButton.userInteractionEnabled = YES;
        self.nextLabel.textColor = [UIColor colorWithHexStr:@"#909090" alpha:1.0];
    }
}

//播放 下一页按钮 变灰不能点击
-(void)leftAndRightButtonGray
{
    self.playImageView.image = [UIImage imageNamed:@"kBook_play_H"];
    self.playButton.userInteractionEnabled = NO;
    self.leftLabel.textColor = [UIColor colorWithHexStr:@"#909090" alpha:0.3];
    
    if (self.pageNum == self.totalPage - 1) {
        self.nextView.hidden = YES;
        self.finishView.hidden = NO;
        
        self.finishImgView.image = [UIImage imageNamed:@"kBook_finish_H"];
        self.finishButton.userInteractionEnabled = NO;
        self.finishLabel.textColor = [UIColor colorWithHexStr:@"#FF5001" alpha:0.3];
        
    }else{
        self.nextView.hidden = NO;
        self.finishView.hidden = YES;
        
        self.nextImageview.image = [UIImage imageNamed:@"kBook_next_H"];
        self.nextButton.userInteractionEnabled = NO;
        self.nextLabel.textColor = [UIColor colorWithHexStr:@"#909090" alpha:0.3];
    }
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
- (NSDictionary *)getAudioSetting
{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setValue:[NSNumber numberWithFloat:ETRECORD_RATE] forKey:AVSampleRateKey];
    //设置通道.只有双通道录音才能转换MP3格式
    [dicM setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32,设置16或32 才能使转换MP3音频长度一致
    [dicM setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    [dicM setObject:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    //....其他设置等
    return dicM;
}

- (void)setAudioSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    //AVAudioSessionCategoryPlayAndRecord用于录音和播放(要不然本地播放不了)
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    
    //如下代码 解决播放器播放录音文件音量小问题
    UInt32 doChangeDefault = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
}

- (NSURL *)getSavePathWithBookID:(NSString *)bookId WithPage:(NSInteger )page
{
    //创建 kbook文件夹路径
    NSString *kbookPath = [self getCacheKbook];
    
    //根据bookId 创建文件夹
    NSString *path = [NSString stringWithFormat:@"%@/%@",kbookPath,bookId];
    if (![self isFileExit:path]) {
        [self createPath:path];
    }
    
    //根据 页数 创建文件
    NSString *savePath = [NSString stringWithFormat:@"%@/%ld.wav",path,(long)page];//格式变更不需要bookid
    self.savePath = savePath;
    NSLog(@"file path:%@",savePath);
    NSURL *url = [NSURL fileURLWithPath:savePath];
    return url;
}

//获取录音文件时长
-(NSInteger)audioSoundDurationWithFilePath:(NSString *)filePath
{
    NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey: @YES};
    
    NSURL *url;
    if ([filePath containsString:@"http"]) {
        url = [NSURL URLWithString:filePath];
    }else{
        url = [NSURL fileURLWithPath:filePath];
    }
    
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:options];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    return audioDurationSeconds;
}

//录音文件检查索引
-(NSArray *)checkRecordFileList
{
    NSMutableArray *mp3MutableArray = [NSMutableArray array];
    for (NSDictionary *mp3Dic in self.mp3PathArray) {
        NSInteger sortNum = [[mp3Dic objectForKey:@"sortNum"] integerValue];
        [mp3MutableArray addObject:[NSNumber numberWithInteger:sortNum]];
    }
    NSArray *mp3Array = [NSArray arrayWithArray:mp3MutableArray];
    
    NSLog(@"mp3Array===>>%@",mp3Array);
    NSArray *difArray = [self CompareDifferentData:self.totalArray WithArray:mp3Array];
    
    return [self compareDataArray:self.dataArray setCompareArray:difArray];;
}

-(NSArray *) compareDataArray:(NSArray *) dataArray setCompareArray:(NSArray *) compareArray
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
        KBookVoiceInfo *voiceInfo = [dataArray objectAtIndex: i];
        
        if ([voiceInfo.status isEqualToString:@"1"]) {
            [tempArray addObject: [NSString stringWithFormat:@"%li",(long)voiceInfo.pageNum]];
        }
        
//        for (int j = 0; j < compareArray.count; j ++) {
//            KBookVoiceInfo *voiceInfo = [dataArray objectAtIndex: i];
//
//            if (voiceInfo < ) {
//
//            }
//
////            KBookVoiceInfo *voiceInfo = [compareArray objectAtIndex: j];
////            if ([voiceInfo.status isEqualToString:@"1"]) {
////                [tempArray addObject: ];
////            }
//        }
    }
    
    NSLog(@"tempArray ==> %@",tempArray);
    NSLog(@"compareArray ==> %@",compareArray);
    
//    NSArray *difArray = [self CompareDifferentData:tempArray WithArray:compareArray];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < compareArray.count; i ++) {
        NSString *str = [compareArray objectAtIndex:i];
        if (tempArray.count > 0) {
            int index = 0;
            for (int j = 0; j < tempArray.count; j ++) {
                NSString *tempStr = [tempArray objectAtIndex:j];
                if (![[NSString stringWithFormat:@"%@",str] isEqualToString: [NSString stringWithFormat:@"%@",tempStr]]) {
                    index ++;
                    if (index == tempArray.count) {
                        [results addObject:str];
                    }
                }
                
            }
        } else {
            [results addObject:str];
        }
        
    }
    
    return results;
}

-(NSArray *)CompareDifferentData:(NSArray *)totalArray WithArray:(NSArray *)array
{
    //比对不同数据(total中mp3不存在的数据)
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",array];
    NSArray *difArray = [totalArray filteredArrayUsingPredicate:filterPredicate];
    
    NSLog(@"totalArray===>%@",totalArray);
    NSLog(@"比对的array===>%@",array);
    
    NSLog(@"对比后的结果====>%@",difArray);
    
  
    return difArray;
}

#pragma mark - 文件路径
// 文件操作
- (NSString*)getCacheKbook
{
    NSString *kbook = [NSString stringWithFormat:@"%@/%@",[self getCachePath],KBOOK_AUDIOPATH];
    if (![self isFileExit:kbook]) {
        [self createPath:kbook];
    }
    return kbook;
}

- (NSString*)getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

-(void)createPath:(NSString*)path
{
    if (![self isFileExit:path]) {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString * parentPath = [path stringByDeletingLastPathComponent];
        if ([self isFileExit:parentPath]) {
            NSError * error;
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:path attributes:nil error:&error];
        }else{
            [self createPath:parentPath];
            [self createPath:path];
        }
    }
}

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

-(BOOL)isFileExit:(NSString*)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

#pragma mark - AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (!self.dataArray.count) {
        return;
    }
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.savePath] options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    //重置定时器
    [self.recordTimer invalidate];
    self.recordTimer = nil;
    self.recordDuration = 0;
    
    if ([self.savePath containsString:@".wav"]) {
        //转换mp3
        NSString *tem = self.savePath;
        NSString *mp3PathTemp = [tem stringByReplacingOccurrencesOfString:@".wav" withString:@".mp3"];
        NSLog(@"wavPath==>%@\n mp3PathTemp==>%@",tem,mp3PathTemp);
        
        __weak typeof(self) wSelf = self;
        
        self.retainCountForThread ++;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self convertAACToMp3:self.savePath setPageNum:self.pageNum withSavePath:mp3PathTemp withBlock:^(NSString *errorInfo,NSInteger pageNum,NSString *mp3Path,NSString *savePath) {
            
            self.retainCountForThread --;
            
                if (!errorInfo) {
                    
                    NSLog(@"将wav格式转换成mp3格式成功");
                    
                    KBookVoiceInfo *voiceInfo = [wSelf.dataArray objectAtIndex:pageNum];
                    NSDictionary *dic = @{@"sortNum":[NSNumber numberWithInteger:voiceInfo.pageNum],@"mp3Path":mp3Path};
                    
                    //先删除重录的
                    for (NSDictionary *mp3Dic in wSelf.mp3PathArray) {
                        NSInteger sortNum = [[mp3Dic objectForKey:@"sortNum"] integerValue];
                        if (sortNum == voiceInfo.pageNum) {
                            [wSelf.mp3PathArray removeObject:mp3Dic];
                            NSLog(@"重复录制次数");
                            break;
                        }
                    }
                    
                    [wSelf.mp3PathArray addObject:dic];
                    
                    NSLog(@"weakSelf.mp3PathArray => %@",wSelf.mp3PathArray);
                    
                    //删除wav文件
                    [wSelf deletePath:savePath];
                }
            }];
//        });
        
    }
}

-(void)convertAACToMp3:(NSString*)aacFilePath setPageNum:(NSInteger) pageNum withSavePath:(NSString*)savePath withBlock:(mp3ConvertBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        @try {
            int read, write;
            
            FILE *pcm = fopen([aacFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
            fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
            FILE *mp3 = fopen([savePath cStringUsingEncoding:1], "wb+");  //output 输出生成的Mp3文件位置
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_num_channels(lame,1);//设置1为单通道，默认为2双通道
            lame_set_in_samplerate(lame, ETRECORD_RATE);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            do {
                
                read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0) {
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                    
                } else {
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                }
                
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_mp3_tags_fid(lame, mp3);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        @catch (NSException *exception) {
            NSLog(@"exception.reason==>%@",exception.reason);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI操作
                
                block(exception.reason,pageNum,savePath,aacFilePath);
            });
            
        }
        @finally {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI操作
                NSLog(@"MP3生成成功: %@",savePath);
                
                block(nil,pageNum,savePath,aacFilePath);
            });
            
            //删除原wav文件
//            [self deletePath:aacFilePath];
        }
    });
    
}

#pragma mark - 拦截返回手势
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //拦截返回手势
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        
        if (self.mp3PathArray.count > 0) {
            
            [self showAlertWithType:Alert_Quit WithTitle:@""];
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 手势相关
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint maskPoint = [[touches anyObject] locationInView:self.collectionView];
    if (CGRectContainsPoint(self.collectionView.frame, maskPoint)) {
        if ([self.recorder record] == YES) {
            [MBProgressHUD showText:@"录音过程中不能滚动图片哦"];
        }
    }
    
    CGPoint alertPoint = [[touches anyObject] locationInView:self.alertMaskView];
    if (CGRectContainsPoint(self.alertMaskView.frame, alertPoint)) {
        self.alertMaskView.hidden = YES;
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint maskPoint = [[touches anyObject] locationInView:self.collectionView];
    if (CGRectContainsPoint(self.collectionView.frame, maskPoint)) {
        if ([self.recorder record] == YES) {
            [MBProgressHUD showText:@"录音过程中不能滚动图片哦"];
        }
    }
    
    CGPoint alertPoint = [[touches anyObject] locationInView:self.alertMaskView];
    if (CGRectContainsPoint(self.alertMaskView.frame, alertPoint)) {
        self.alertMaskView.hidden = YES;
    }
}

//OSS处理图片
-(NSString *)disposeImageWithUrl:(NSString *)urlStr WithParameter:(NSString *)parameter
{
    NSString *string;
    if (urlStr != nil && ![urlStr isEqualToString:@""]) {
        string = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,%@",urlStr,parameter];
    }
    return string;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
