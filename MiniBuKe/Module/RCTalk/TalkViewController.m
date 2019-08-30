//
//  TalkViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TalkViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TalkMessageModel.h"
#import "UIImage+XBK.h"
#import "RCTalkRecordTool.h"
#import "MessageToRobotService.h"
#import "FileUploadService.h"
#import "CustomVoiceMessage.h"
#import "VoiceUserInfo.h"
#import "MusicPlayTool.h"
#import "TalkKeybord.h"
#import "EmojiObject.h"
#import "MBProgressHUD+XBK.h"
#import "TalkVoiceCell.h"
#import "TalkImageCell.h"
#import "BabyRobotInfo.h"
#import "UserLoginViewController.h"
#import "DataBaseTool.h"
#import "TencentIMManager.h"
#import "ObserveArrayObject.h"
#import "TalkPlaceHoderView.h"
#import "CommonUsePackaging.h"
#define bottomView_height 60
#define KEYBORD_HEIGHT 195
#define Recording_Time 99.0

#define CUSTOM_MESSAGETYPE  @"xbk:voicePlay"
#define TALKCACH    @"talkCach"

#import "BKNewLoginController.h"
#import "BKMessageNODataBackView.h"
#import "JDOSSUploadfileHandle.h"
//
@interface TalkViewController ()<UITableViewDelegate, UITableViewDataSource,MusicPlayToolDelegate,TalkKeybordDelegate,UIGestureRecognizerDelegate,RCIMClientReceiveMessageDelegate,RCConnectionStatusChangeDelegate>
{
    struct Play{
         int newPlay;
         int lastPlay;
    }currentPlay;
}
@property(nonatomic,strong)TalkPlaceHoderView * talkPlaceHoderView;
@property(nonatomic,strong) ObserveArrayObject *observeObject;

@property(nonatomic,strong) NSMutableArray *cachDataArray;
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) TalkKeybord *talkKeybord;

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *talKView;
@property(nonatomic,strong) UILabel *talkLabel;
@property(nonatomic,strong) UIButton *talkbutton;

@property(nonatomic,strong) UIView *callMaskView;
@property(nonatomic,strong) UIView *callView;//录音动画基础View
@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UIImageView *yinjieImgView;
@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UIImageView *chexiaoImg;

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) CGPoint temPoint;
@property(nonatomic,assign) NSInteger endState;//记录松开手指是发送还是取消发送
//录音
@property(nonatomic,strong) RCTalkRecordTool *recordTool;
@property(nonatomic,strong) MusicPlayTool *playTool;

@property(nonatomic,strong) NSArray *emojiArray;

@property(nonatomic,assign) BOOL isScrollBottom;

@property(nonatomic,strong) TalkMessageModel *mPlayingTalkMessageModel;

//@property(nonatomic,strong) NSKSafeMutableArray *safeArray;

@property(nonatomic,strong) NSTimer *recordTimer;
@property(nonatomic,assign) NSInteger recordDuration;
@property(nonatomic) BOOL isCanSideBack;
@property(nonatomic,assign)BOOL hasMessage;
@end

@implementation TalkViewController

-(NSArray *)emojiArray
{
    if (!_emojiArray) {
        _emojiArray = [CommonUsePackaging shareInstance].emojiArray;
    }
    
    return _emojiArray;
}
-(TalkPlaceHoderView *)talkPlaceHoderView
{
    if (!_talkPlaceHoderView) {
        _talkPlaceHoderView = [[TalkPlaceHoderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) Talk:Talk_Type];
    }
    return _talkPlaceHoderView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recordDuration = 0;
    currentPlay.lastPlay = -1;
    currentPlay.newPlay = -1;
    [UIApplication sharedApplication].idleTimerDisabled = NO;//屏幕息屏
    
    //清除消息角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if (4 == [APP_DELEGATE.snData.type integerValue]) {
        [self addDataTempView];
        return;
    }
    
    //融云监听
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];
    //注册自定义消息类型
    [[RCIMClient sharedRCIMClient] registerMessageType:[CustomVoiceMessage class]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSMutableArray arrayWithCapacity:0] forKey:@"array"];
    self.observeObject = [[ObserveArrayObject alloc] initWithDic:dic];
    [self.observeObject addObserver:self forKeyPath:@"array" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self initView];
    
    self.playTool = [MusicPlayTool shareMusicPlay];
    self.playTool.delegat = self;
    [self recordAuthor];
    NSArray *array = [DataBaseTool selectModelData];
    NSMutableArray *temArray = [NSMutableArray array];
    
    if (array.count > 0) {
//        self.messageArray = [NSMutableArray arrayWithArray:array];
        [temArray addObjectsFromArray:array];
//        self.cachDataArray = [NSMutableArray arrayWithArray:array];
//        [self.messageArray addObjectsFromArray:self.observeArray];
        NSArray *sortArray = [self dateSortArray:temArray];
        [[self.observeObject mutableArrayValueForKey:@"array"] addObjectsFromArray:sortArray];
        
    }else{
        self.hasMessage = NO;
        [self.view addSubview:self.talkPlaceHoderView];
////        self.messageArray = [NSMutableArray array];
//        self.cachDataArray = [NSMutableArray array];
////        [self.messageArray addObjectsFromArray:self.observeArray];
//        [temArray addObjectsFromArray:self.observeArray];
     
    }
  
//    [[TencentIMManager defautManager] getAllmessagesCallback:^(NSArray *array) {
//
//        if (array.count == 0) {
//            self.hasMessage = NO;
//            [self.view addSubview:self.talkPlaceHoderView];
//        }else
//        {
//            self.hasMessage = YES;
//            [temArray addObjectsFromArray:array];
//            NSLog(@"temArray==>%@",temArray);
//            NSArray *sortArray = [self dateSortArray:temArray];
//            [[self.observeObject mutableArrayValueForKey:@"array"] addObjectsFromArray:sortArray];
//        }
//
//
//    }];
   
   
    
   
}

- (void)addDataTempView{
    CGRect imageBound = CGRectMake(0, 0, 375, 200);
    UIImage *backImage = [UIImage imageNamed:@"Message_babyCare_NOUser"];
    NSString *title = @"此设备暂不支持该功能";
    BKMessageNODataBackView *backView = [[BKMessageNODataBackView alloc]initWithImageBound:imageBound WithImage:backImage WithTitle:title andPicOffset:-50 andLableOffset:-15];
    backView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    backView.backgroundColor = COLOR_STRING(@"#F7F9FB");
    backView.titlefont = [UIFont systemFontOfSize:13.f];
    backView.titlefontColor = COLOR_STRING(@"#999999");
    [self.view addSubview:backView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSUInteger rowCount = [self.tableView numberOfRowsInSection:0];
    if (rowCount > 0) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCount - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
    //腾讯Im新消息通知
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReceiveTencentMessage:) name:TENCENTIMMESSAGE object:nil];
    
    
}

#pragma mark - 监听腾讯IM收到消息 
-(void)ReceiveTencentMessage:(NSNotification*)notif
{
   
    TalkMessageModel *model = (TalkMessageModel*)notif.object;
    if (model.nickName.length==0) {
        model.nickName = @"小布壳";
    }
    if (model!=nil) {
        if (self.receiveMessageBlock) {
            self.receiveMessageBlock();
        }
      
        [[self.observeObject mutableArrayValueForKey:@"array"] addObject:model];
        
        //按照时间戳进行排序
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self dateSortArray:[self.observeObject mutableArrayValueForKey:@"array"]];
        });
    }
  
}
#pragma mark - 腾讯IM发送消息
-(void)TencentSendMessage:(NSString *)urlStr withMessageType:(MessageType )type withDurationTime:(NSInteger)durationTime{
    if (!self.hasMessage) {
        if ([self.view.subviews containsObject:self.talkPlaceHoderView]) {
            [self.talkPlaceHoderView removeFromSuperview];
        }
        self.hasMessage = YES;
    }
    
    [[TencentIMManager defautManager] sendTextMessage:urlStr Imtime:[NSString stringWithFormat:@"%ld",(long)durationTime] succ:^{
        [self funMesaage:urlStr withMessageType:type withDurationTime:durationTime Result:YES];

    } fail:^(int code, NSString *msg) {
        [self funMesaage:urlStr withMessageType:type withDurationTime:durationTime Result:NO];
        [self showSystemHint:urlStr withMessageType:type withDurationTime:durationTime];

    }];
    
}
#pragma mark - 未发送失败提醒
-(void)showSystemHint:(NSString *)urlStr withMessageType:(MessageType )type withDurationTime:(NSInteger)durationTime
{
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:nil message:@"是否重发该消息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self TencentSendMessage:urlStr withMessageType:type withDurationTime:durationTime];
        [self sendMessageWithUrl:urlStr messageType:MessageTypeText durationTime:durationTime];
    }];
    [tipAlert addAction:cancelAction];
    [tipAlert addAction:cancelAction1];
    [self presentViewController:tipAlert animated:YES completion:nil];
}

#pragma mark - 处理消息(以前代码)
-(void)funMesaage:(NSString *)urlStr withMessageType:(MessageType )type withDurationTime:(NSInteger)durationTime Result:(BOOL)result{
    
    NSString *currentTime = [self getCurrentTime];
    TalkMessageModel *model = [[TalkMessageModel alloc]init];
    model.messageType = type;
    model.messageSenderType = MessageSenderTypeSelf;
    if (result) {
        model.messageSentStatus = MessageSentStatusSended;
    }else
    {
        model.messageSentStatus = MessageSentStatusUnSended;
    }
    model.showNickName = NO;
    //    model.showMessageTime = YES;
    model.messageTime = currentTime;
    model.logoUrl = model.logoUrl;
    
    //    if (self.messageArray == nil || self.messageArray.count == 0)
    if (self.observeObject.array == nil || self.observeObject.array.count == 0){
        model.showMessageTime = YES;
        model.messageTime = currentTime;
    }else{
        //        TalkMessageModel *lastModel = [self.messageArray lastObject];
        TalkMessageModel *lastModel = [self.observeObject.array lastObject];
        //        BOOL isShow = [self compareTimeWith:lastModel.messageTime];
        BOOL isShow = [self compareTime:lastModel.messageTime WithOtherTime:currentTime];
        if (isShow == NO) {
            model.showMessageTime = NO;
        }else{
            model.showMessageTime = YES;
        }
    }
    
    if (type == MessageTypeImage) {
        //是图片 必须设置model.imageSmall属性
        NSString *imgeUrl = nil;
        for (EmojiObject *object in self.emojiArray) {
            if ([object.voiceUrl isEqualToString:urlStr]) {
                imgeUrl = object.imageUrl;
                break;
            }
        }
        if (imgeUrl != nil) {
            model.imageSmall = [UIImage imageNamed:imgeUrl];
        }
    }
    if (urlStr != nil) {
        //        model.duringTime = [self getAudioDurationByUrl:urlStr];
        model.duringTime = durationTime/1000;
        model.voiceUrl = urlStr;
    }
    
    //    [self.messageArray addObject:model];
    [[self.observeObject mutableArrayValueForKey:@"array"] addObject:model];
    //排序
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self dateSortArray:[self.observeObject mutableArrayValueForKey:@"array"]];
    });
}

#pragma mark - 停止动画
-(void)StopVoiceAnimationIndex:(NSInteger)index{
    
    if (currentPlay.newPlay != currentPlay.lastPlay && currentPlay.lastPlay>=0) {
        TalkMessageModel *model = self.observeObject.array[index];
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0 ];
        if (model.messageType == MessageTypeImage)
        {
            
            TalkImageCell *cell = [self.tableView cellForRowAtIndexPath:path];
            
            [cell stopVoiceAnimation];
        }else
        {
            TalkVoiceCell *cell = [self.tableView cellForRowAtIndexPath:path];
            [cell stopVoiceAnimation];
        }
    }
  
}


#pragma mark - public
-(void)stopVoiceAnimationing{
//    NSLog(@"currentPlay.newPlay==>%d",currentPlay.newPlay);
    if (currentPlay.newPlay>=0) {
        TalkMessageModel *model = self.observeObject.array[currentPlay.newPlay];
        NSIndexPath *path = [NSIndexPath indexPathForRow:currentPlay.newPlay inSection:0 ];
        if (model.messageType == MessageTypeImage)
        {
            
            TalkImageCell *cell = [self.tableView cellForRowAtIndexPath:path];
            
            [cell stopVoiceAnimation];
        }else
        {
            TalkVoiceCell *cell = [self.tableView cellForRowAtIndexPath:path];
            [cell stopVoiceAnimation];
        }
    }
  
}
-(void)stopPlay{
    [[MusicPlayTool shareMusicPlay] musicPause];
    self.mPlayingTalkMessageModel = nil;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
    return self.isCanSideBack;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.size.height) animated:NO];
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    self.isCanSideBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
    

    [[MusicPlayTool shareMusicPlay] musicPause];
    [self.playTool.player replaceCurrentItemWithPlayerItem:nil];
    self.playTool = nil;
    //移除腾讯Im新消息通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:TENCENTIMMESSAGE object:nil];
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self resetSideBack];
    
    [self.timer invalidate];
     self.timer = nil;
    
    [self.recordTimer invalidate];
    self.recordTimer = nil;
    
    
}

- (void)resetSideBack {
    
    self.isCanSideBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


-(void)dealloc
{
    [self.observeObject removeObserver:self forKeyPath:@"array"];
    [self.callMaskView removeObserver:self forKeyPath:@"hidden"];
    NSLog(@"==> dealloc");
    
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

- (void)initView{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kNavbarH)];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomView_height, self.view.frame.size.width, bottomView_height)];
    [self.view addSubview:_bottomView];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height)];

    [self.view addSubview:_middleView];
    
//    [self createTopViewChild];
    [self createBottomViewChild];
    [self createMiddleViewChild];
    [self createAnimationView];
}

-(void)createAnimationView
{
    UIView *callMaskView = [[UIView alloc] init];
    callMaskView.frame = APP_DELEGATE.window.bounds;
    callMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    callMaskView.hidden = YES;
    callMaskView.userInteractionEnabled = YES;
    self.callMaskView = callMaskView;
    [APP_DELEGATE.window addSubview:callMaskView];
    [self.callMaskView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    UIView *callView = [[UIView alloc]init];
    callView.layer.cornerRadius = 6;
    callView.clipsToBounds = YES;
    callView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    callView.hidden = YES;
    self.callView = callView;
    [callMaskView addSubview:callView];
    [callView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(125, 125));
        make.center.mas_equalTo(CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2));
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:11];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"手指上滑，取消发送";
    label.layer.cornerRadius = 2;
    label.clipsToBounds = YES;
    label.textColor = [UIColor whiteColor];
    self.label = label;
    [callView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(callView).offset(5);
//        make.right.equalTo(callView).offset(-5);
        make.centerX.mas_equalTo(callView.mas_centerX);
        make.bottom.equalTo(callView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(115, 23));
    }];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yuyin"]];
    self.imgView = imgView;
    [callView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(callView.mas_centerX);
        make.centerY.equalTo(callView).offset(-13);
        make.size.mas_equalTo(CGSizeMake(35, 57));
    }];
    
    UIImageView *chexiaoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chexiao"]];
    chexiaoImg.hidden = YES;
    self.chexiaoImg = chexiaoImg;
    [callView addSubview:chexiaoImg];
    [chexiaoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(callView);
        make.centerY.equalTo(callView).offset(-13);
        make.size.mas_equalTo(CGSizeMake(48, 58));
    }];
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectZero];
    maskView.backgroundColor = [UIColor whiteColor];
    self.maskView = maskView;
    [callView addSubview:maskView];
    
    UIImageView *yinjieImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    yinjieImgView.translatesAutoresizingMaskIntoConstraints = NO;
    yinjieImgView.image = [UIImage imageNamed:@"yinjie（6）"];
    self.yinjieImgView = yinjieImgView;
    [callView addSubview:yinjieImgView];
    [yinjieImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(callView.mas_centerX);
        make.centerY.equalTo(callView).offset(-2);
    }];
}

-(void) createBottomViewChild
{
    
    UIButton *talkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    talkButton.frame = CGRectMake(15, 10, _bottomView.frame.size.width - 15 - 30 - 15 - 15, _bottomView.frame.size.height - 10*2);
    talkButton.layer.cornerRadius = talkButton.frame.size.height/2;
    talkButton.layer.borderWidth = 1.0f;
    talkButton.layer.borderColor = COLOR_STRING(@"#D7D7D7").CGColor;
    talkButton.layer.masksToBounds = YES;
    talkButton.enabled = NO;//点击逻辑往上UITouch
    talkButton.titleLabel.font = MY_FONT(17);
    [talkButton setTitleColor:COLOR_STRING(@"#2F2F2F") forState:UIControlStateNormal];
    [talkButton setTitleColor:COLOR_STRING(@"#2F2F2F") forState:UIControlStateHighlighted];
    [talkButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [talkButton setImage:[UIImage imageNamed:@"maikefeng"] forState:UIControlStateNormal];
    [talkButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    self.talkbutton = talkButton;
    [_bottomView addSubview:talkButton];
    
    UIImageView *buttonImgView = [[UIImageView alloc] init];
    buttonImgView.frame = CGRectMake(_bottomView.frame.size.width - 30 - 15, (_bottomView.frame.size.height - 30)*0.5, 30, 30);
    buttonImgView.image = [UIImage imageNamed:@"说说_表情"];
    buttonImgView.userInteractionEnabled = YES;
    [_bottomView addSubview:buttonImgView];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(CGRectGetMaxX(talkButton.frame), 0, SCREEN_WIDTH-CGRectGetMaxX(talkButton.frame), _bottomView.bounds.size.height);
    rightButton.selected = NO;
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"说说_表情"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:rightButton];
    
    
    self.talkKeybord = [[TalkKeybord alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - KEYBORD_HEIGHT, self.view.frame.size.width, KEYBORD_HEIGHT)];
    self.talkKeybord.delegate = self;
    self.talkKeybord.hidden = YES;
    [self.view addSubview:self.talkKeybord];
}

-(void) createMiddleViewChild
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height) style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:COLOR_STRING(@"#F7F9FB")];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_middleView addSubview:self.tableView];
    

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeybord)];
    [self.tableView addGestureRecognizer:tapGesture];
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
    titleLabel.text = @"说说";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}

-(IBAction)backButtonClick:(id)sender
{
    [self hiddenKeybord];
    [self.navigationController popViewControllerAnimated:YES];
}

//伸缩键盘
-(void)clickRightBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        //弹出表情键盘
        [self showTalkKeybord];
    }else{
        [self hideTalkKeybord];
    }
}

#pragma mark - TalkKeybordDelegate
//发送表情语音
-(void)clickSendEmoji:(UIButton *)sender
{
    EmojiObject *emojiObj = self.emojiArray[sender.tag];
    NSString *emojiUrl = emojiObj.voiceUrl;
    if (emojiUrl != nil && ![emojiUrl isEqualToString:@""]) {
        
        NSInteger durationTime = [self getAudioDurationByUrl:emojiUrl] * 1000;
        
//        [self sendMessageWithUrl:emojiUrl messageType:MessageTypeImage];
        [self sendMessageWithUrl:emojiUrl messageType:MessageTypeImage durationTime:durationTime];
//        [self TencentSendMessage:emojiUrl withMessageType:MessageTypeImage withDurationTime:durationTime];
        
    }
}

-(void)showTalkKeybord
{
    //创建弹出键盘
    self.talkKeybord.hidden = NO;
    
    _bottomView.frame = CGRectMake(0, self.talkKeybord.frame.origin.y - bottomView_height, self.view.frame.size.width, bottomView_height);
    
    _middleView.frame = CGRectMake(0, _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height - self.talkKeybord.frame.size.height);
    
    self.tableView.frame = CGRectMake(0,0, self.view.frame.size.width, _middleView.frame.size.height);
    
    //让会话 滑动到最底部
//    if (self.messageArray.count > 0)
    if (self.observeObject.array.count > 0){
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.messageArray.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.observeObject.array.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
}

-(void)hideTalkKeybord
{
    self.talkKeybord.hidden = YES;
    
    _bottomView.frame = CGRectMake(0, self.view.frame.size.height - bottomView_height, self.view.frame.size.width, bottomView_height);
    _middleView.frame = CGRectMake(0, _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height);
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, _middleView.frame.size.height);
}

#pragma mark - RCConnectionStatusChangeDelegate
//监听云服务器连接状态
-(void)onConnectionStatusChanged:(RCConnectionStatus)status
{
    switch (status) {
        case ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT:
        {
            NSLog(@"用户在其他设备上登录");
            [MBProgressHUD showText:@"用户在其他设备上登录"];

            [APP_DELEGATE removeLoginResult];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WechatUserInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                BKNewLoginController *LoginController = [[BKNewLoginController alloc]init];
                APP_DELEGATE.navigationController = [[BKNavgationController alloc] initWithRootViewController:LoginController];
                APP_DELEGATE.window.rootViewController = APP_DELEGATE.navigationController;
            });

        }
            break;
        case ConnectionStatus_Connecting:
            NSLog(@"连接中...");
            break;
        case ConnectionStatus_Unconnected:
            NSLog(@"连接失败/未连接");
            break;
        case ConnectionStatus_SignUp:
            NSLog(@"已注销");
            [MBProgressHUD showText:@"用户已注销"];
            break;
        case ConnectionStatus_TOKEN_INCORRECT:
            NSLog(@"TOKEN无效");
            [MBProgressHUD showText:@"TOKEN无效"];
            break;
        case ConnectionStatus_DISCONN_EXCEPTION:
            NSLog(@"与服务器的连接已断开,用户被封禁");
            [MBProgressHUD showText:@"与服务器的连接已断开,用户被封禁"];
            break;
            
        default:
            break;
    }
}

#pragma mark - RCIMClientReceiveMessageDelegate
//监听消息
-(void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    NSLog(@"RCMessage == > %@",message);
    if (self.receiveMessageBlock) {
        self.receiveMessageBlock();
    }
    //绑定时间戳
    NSString *bandingTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Banding_Timestamp"];

    if (bandingTimeStr.length > 0 && bandingTimeStr != nil) {
        long long bandingTime = [bandingTimeStr integerValue];

        NSLog(@"bandingTime === %lld, message.sentTime=== %lld",bandingTime,message.sentTime);

        if (bandingTime > message.sentTime) {
            return;
        }
    }

    //先判断消息类型
    if ([message.objectName isEqualToString:CUSTOM_MESSAGETYPE])
    {
        if ([message.content isMemberOfClass:[CustomVoiceMessage class]]){
            CustomVoiceMessage *voiceMsg = (CustomVoiceMessage *)message.content;

            NSString *receivedTime = [NSString stringWithFormat:@"%lld",message.sentTime];

            NSString *urlStr = nil;
            if (voiceMsg.voice != nil && voiceMsg.voice.length != 0 && ![voiceMsg.voice isEqualToString:@""]) {
                urlStr = voiceMsg.voice;
            }

            if (voiceMsg.extra != nil && voiceMsg.extra.length != 0 && ![voiceMsg.extra isEqualToString:@""]){
//                NSLog(@"voiceMsg.extra --- >%@",voiceMsg.extra);
                NSDictionary *dic = [self parseJSONStringToNSDictionary:voiceMsg.extra];
//                NSLog(@"解析后的字典:%@",dic);

                if ([[dic allKeys] containsObject:@"babyNickName"]) {
                    //机器人发来的消息
                    BabyRobotInfo *babyInfo = [BabyRobotInfo parseDataByDictionary:dic];
                    [self updateRobotMessage:babyInfo voiceUrl:urlStr timestamp:receivedTime];
                }else{
                    VoiceUserInfo *userInfo = [VoiceUserInfo parseDataByDictionary:dic];
                    NSDictionary *localDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginResult"];

                    NSString *usrName = [localDic objectForKey:@"userName"];

                    if ([userInfo.userName isEqualToString:usrName]) {
                        //自己发的消息
                        return;
                    }else{
                        [self updateMessageOther:userInfo voiceUrl:urlStr timestamp:receivedTime];
                    }
                }

            }
        }
    }

}

-(void)updateMessageOther:(VoiceUserInfo *)info voiceUrl:(NSString *)urlStr timestamp:(NSString *)timestamp
{
    NSString *messageTime = [self getMessageTimeByTimestamp:timestamp];
    TalkMessageModel *model = [[TalkMessageModel alloc]init];
    model.messageSenderType = MessageSenderTypeOther;
    model.mId = 0;
    model.messageReadStatus = MessageReadStatusUnRead;
    model.showNickName = YES;
    model.logoUrl = info.imageUrl;
    model.messageType = MessageTypeVoice;
    model.messageTime = messageTime;

    if (info.appellativeName.length > 0) {
        model.nickName = info.appellativeName;
    }else{
//        if (info.nickName.length > 0) {
//            model.nickName = info.nickName;
//        }
//        else{
//            model.nickName = info.userName;
//        }
    }

//    if (self.messageArray == nil || self.messageArray.count == 0)
    if (self.observeObject.array == nil || self.observeObject.array.count == 0){
        model.showMessageTime = YES;
        model.messageTime = messageTime;
    }else{

//        TalkMessageModel *lastModel = [self.messageArray lastObject];
        TalkMessageModel *lastModel = [self.observeObject.array lastObject];
//        BOOL isShow = [self compareTimeWith:lastModel.messageTime];
        BOOL isShow = [self compareTime:lastModel.messageTime WithOtherTime:messageTime];
        if (isShow == NO) {
            model.showMessageTime = NO;
        }else{
            model.showMessageTime = YES;
        }
    }

    for (EmojiObject *object in self.emojiArray) {
        if ([urlStr isEqualToString:object.voiceUrl]) {
            //表情 语音
            model.messageType = MessageTypeImage;
            model.imageSmall = [UIImage imageNamed:object.imageUrl];
            break;
        }
    }

    if (urlStr != nil) {
        model.voiceUrl = urlStr;
        NSInteger durationTime = info.imTime;
        if (durationTime > 0) {
            model.duringTime = info.imTime/1000;
        }else{
            model.duringTime = [self getAudioDurationByUrl:urlStr];
        }
    }

//    [self.messageArray addObject:model];
    [[self.observeObject mutableArrayValueForKey:@"array"] addObject:model];

    //按照时间戳进行排序
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self dateSortArray:[self.observeObject mutableArrayValueForKey:@"array"]];
    });


    //缓存数据库
    [DataBaseTool addMessageModel:model];

}

-(void)updateRobotMessage:(BabyRobotInfo *)babyInfo voiceUrl:(NSString *)urlStr timestamp:(NSString *)timestamp
{
    NSString *messageTime = [self getMessageTimeByTimestamp:timestamp];

    TalkMessageModel *model = [[TalkMessageModel alloc] init];
    model.messageType = MessageTypeVoice;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageReadStatus = MessageReadStatusUnRead;
    model.mId = 0;
    model.logoUrl = @"";//babyInfo.babyImageUrl;
    model.showNickName = YES;
//    model.showMessageTime = YES;
    model.messageTime = messageTime;
//    if (self.messageArray == nil || self.messageArray.count == 0)
    if (self.observeObject.array == nil || self.observeObject.array.count == 0){
        model.showMessageTime = YES;
        model.messageTime = messageTime;
    }else{
//        TalkMessageModel *lastModel = [self.messageArray lastObject];
        TalkMessageModel *lastModel = [self.observeObject.array lastObject];
//        BOOL isShow = [self compareTimeWith:lastModel.messageTime];
        BOOL isShow = [self compareTime:lastModel.messageTime WithOtherTime:messageTime];
        if (isShow == NO) {
            model.showMessageTime = NO;
        }else{
            model.showMessageTime = YES;
        }
    }

//    if (babyInfo.babyNickName != nil && ![babyInfo.babyNickName isEqualToString:@""]) {
//        model.nickName = babyInfo.babyNickName;
//    }else{
        model.nickName = @"小布壳";
//    }
    if (urlStr != nil && ![urlStr isEqualToString:@""]) {
        model.voiceUrl = urlStr;
        NSInteger durationTime = babyInfo.imTime;
        if (durationTime > 0) {
            model.duringTime = durationTime/1000;
        }else{
            model.duringTime = [self getAudioDurationByUrl:urlStr];
        }
    }

//    [self.messageArray addObject:model];
    [[self.observeObject mutableArrayValueForKey:@"array"] addObject:model];
    //排序
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self dateSortArray:[self.observeObject mutableArrayValueForKey:@"array"]];
    });

    //缓存数据库
    [DataBaseTool addMessageModel:model];
}

-(void)updateMessageSelf:(NSString *)urlStr withMessageType:(MessageType )type withDurationTime:(NSInteger)durationTime
{
    NSString *currentTime = [self getCurrentTime];

    TalkMessageModel *model = [[TalkMessageModel alloc]init];
    model.messageType = type;
    model.messageSenderType = MessageSenderTypeSelf;
    model.showNickName = NO;
//    model.showMessageTime = YES;
    model.messageTime = currentTime;
    model.logoUrl = APP_DELEGATE.mLoginResult.imageUlr;

//    if (self.messageArray == nil || self.messageArray.count == 0)
    if (self.observeObject.array == nil || self.observeObject.array.count == 0){
        model.showMessageTime = YES;
        model.messageTime = currentTime;
    }else{
//        TalkMessageModel *lastModel = [self.messageArray lastObject];
        TalkMessageModel *lastModel = [self.observeObject.array lastObject];
//        BOOL isShow = [self compareTimeWith:lastModel.messageTime];
        BOOL isShow = [self compareTime:lastModel.messageTime WithOtherTime:currentTime];
        if (isShow == NO) {
            model.showMessageTime = NO;
        }else{
            model.showMessageTime = YES;
        }
    }

    if (type == MessageTypeImage) {
        //是图片 必须设置model.imageSmall属性
        NSString *imgeUrl = nil;
        for (EmojiObject *object in self.emojiArray) {
            if ([object.voiceUrl isEqualToString:urlStr]) {
                imgeUrl = object.imageUrl;
                break;
            }
        }
        if (imgeUrl != nil) {
            model.imageSmall = [UIImage imageNamed:imgeUrl];
        }
    }
    if (urlStr != nil) {
//        model.duringTime = [self getAudioDurationByUrl:urlStr];
        model.duringTime = durationTime/1000;
        model.voiceUrl = urlStr;
    }

//    [self.messageArray addObject:model];
    [[self.observeObject mutableArrayValueForKey:@"array"] addObject:model];
    //排序
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self dateSortArray:[self.observeObject mutableArrayValueForKey:@"array"]];
    });

    //缓存数据库
    [DataBaseTool addMessageModel:model];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return  self.messageArray.count;
    return  self.observeObject.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TalkMessageModel *model = self.messageArray[indexPath.row];
    TalkMessageModel *model = self.observeObject.array[indexPath.row];
    if (model.mId != 0) {
        id obj = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",model.mId ]];
        if (obj != nil) {
            model.messageReadStatus = MessageReadStatusRead;
        }
    } else {
        id obj = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",model.voiceUrl ]];
        if (obj != nil) {
            model.messageReadStatus = MessageReadStatusRead;
        }
    }
    
    
    
//    NSLog(@"tableView.indexPath.row---->%ld",indexPath.row);
    
    id cell;
    if (model.messageType == MessageTypeVoice) {
        cell = [TalkVoiceCell cellWithTableView:tableView messageModel:model];
        TalkVoiceCell *voiceCell = (TalkVoiceCell *)cell;
        voiceCell.messageModel = model;
        
        __weak typeof(voiceCell) weakCell = cell;
        [voiceCell setSingleblock:^(TalkMessageModel *model) {
//            weakCell.readView.hidden = YES;
            currentPlay.lastPlay = currentPlay.newPlay;
            currentPlay.newPlay = (int)indexPath.row;
            [self StopVoiceAnimationIndex:currentPlay.lastPlay];
            NSLog(@"==> voiceCell setSingleblock <==");
            if (model.voiceUrl != nil) {
                
                if (self.mPlayingTalkMessageModel != nil && self.mPlayingTalkMessageModel == model) {
                    [[MusicPlayTool shareMusicPlay] musicPause];
                    [weakCell stopVoiceAnimation];
                    
                    self.mPlayingTalkMessageModel = nil;
                    NSLog(@"2 voiceCell ==> %p",weakCell);
                } else {
                    NSLog(@"1 voiceCell ==> %p",weakCell);
                    self.mPlayingTalkMessageModel = model;
                    [[MusicPlayTool shareMusicPlay] musicPause];
                    [weakCell stopVoiceAnimation];
                    
                    [MusicPlayTool shareMusicPlay].urlString = model.voiceUrl;
                    [[MusicPlayTool shareMusicPlay] musicPrePlay];
                    [weakCell startVoiceAnimation];
                }
                
//                model.messageReadStatus = MessageReadStatusRead;
            }
        }];
        
        if ([[MusicPlayTool shareMusicPlay] PlayStatuse]) {
            
            if (self.mPlayingTalkMessageModel != nil && self.mPlayingTalkMessageModel == model) {
                [cell startVoiceAnimation];
            }
            
        }
        
    }else if (model.messageType == MessageTypeImage){
        cell = [TalkImageCell cellWithTableView:tableView messageModel:model];
        TalkImageCell *imgCell = (TalkImageCell *)cell;
        imgCell.messageModel = model;

        __weak typeof(imgCell) weakCell = cell;
        [imgCell setSingleblock:^(TalkMessageModel *model) {
            currentPlay.lastPlay = currentPlay.newPlay;
            currentPlay.newPlay = (int)indexPath.row;
            [self StopVoiceAnimationIndex:currentPlay.lastPlay];
//            weakCell.readView.hidden = YES;
            if (model.voiceUrl != nil) {
                
//                self.palyingCell = cell;
                
                if (self.mPlayingTalkMessageModel != nil && self.mPlayingTalkMessageModel == model) {
                    [[MusicPlayTool shareMusicPlay] musicPause];
                    [weakCell stopVoiceAnimation];
                    
                    self.mPlayingTalkMessageModel = nil;
                    NSLog(@"2 imgCell ==> %p",weakCell);
                } else {
                    NSLog(@"1 imgCell ==> %p",weakCell);
                    self.mPlayingTalkMessageModel = model;
                    [[MusicPlayTool shareMusicPlay] musicPause];
                    [weakCell stopVoiceAnimation];
                    
                    [MusicPlayTool shareMusicPlay].urlString = model.voiceUrl;
                    [[MusicPlayTool shareMusicPlay] musicPrePlay];
                    [weakCell startVoiceAnimation];
                }
            }
        }];
        
        if ([[MusicPlayTool shareMusicPlay] PlayStatuse]) {
            
            if (self.mPlayingTalkMessageModel != nil && self.mPlayingTalkMessageModel == model) {
                [cell startVoiceAnimation];
            }
            
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
//    TalkMessageModel *model = self.messageArray[indexPath.row];
    TalkMessageModel *model = self.observeObject.array[indexPath.row];
    if (model.messageType == MessageTypeVoice) {
        height = [TalkVoiceCell tableHeightWithModel:model];
    }else {
        height = [TalkImageCell tableHeightWithModel:model];
    }
    
    return height;
}

-(void)stopRecordAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{

        [self.talkbutton setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
        self.talkbutton.titleLabel.text = @"按住 说话";
        
        self.callMaskView.hidden = YES;
        self.callView.hidden = YES;
        
    });
    
    [self.timer invalidate];
    self.timer = nil;
    
    //结束录音
    [self stopTalkRecord];
}

#pragma mark - 触摸相关
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [UIApplication sharedApplication].idleTimerDisabled = YES;//禁用屏幕息屏
    
    if (self.talkKeybord.hidden == NO) {
        
        self.callView.center = CGPointMake(SCREEN_WIDTH/2,  SCREEN_HEIGHT/2 - 30);
        
    }else{
        self.callView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    }
    
//    CGPoint maskPoint = [[touches anyObject] locationInView:self.callMaskView];
    
//    NSLog(@"maskPoint.y ----> %f",maskPoint.y);
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(self.bottomView.frame, touchPoint)) {
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self.talkbutton setBackgroundColor:COLOR_STRING(@"#D3D3D3")];
            self.talkbutton.titleLabel.text = @"松开 结束";
            self.callMaskView.hidden = NO;
            self.callView.hidden = NO;
            self.yinjieImgView.hidden = NO;
            self.imgView.hidden = NO;
            self.chexiaoImg.hidden = YES;
            self.label.text = @"手指上滑，取消发送";
            self.label.backgroundColor = [UIColor clearColor];
//        });
        
        //开始录音
        [self recordMessage];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
        self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        
    }else{
        self.talkKeybord.hidden = YES;
    }
    
//    NSLog(@"touchesBegan");
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.bottomView];
    
//    NSLog(@"MovedtouchPoint.y===%f",touchPoint.y);
    
    if (touchPoint.y < 0) {
        self.endState = 0;//0 取消发送
        self.yinjieImgView.hidden = YES;
        self.imgView.hidden = YES;
        self.chexiaoImg.hidden = NO;
        self.label.text = @"松开手指，取消发送";
        self.label.backgroundColor = COLOR_STRING(@"#AE2726");
    }else{
        self.endState = 1;//1 发送
        self.yinjieImgView.hidden = NO;
        self.imgView.hidden = NO;
        self.chexiaoImg.hidden = YES;
        
        self.label.text = @"手指上滑，取消发送";
        self.label.backgroundColor = [UIColor clearColor];
    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self stopRecordAnimation];
    
//    [self sendMessage];
    
//    NSLog(@"touchesEnded");
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self stopRecordAnimation];
    
//    __weak typeof(self) weakSelf = self;
//
//    self.recordTool.finishBlock = ^(NSString *wavPath, NSString *mp3Path, float recordTime){
//        [weakSelf.recordTool deletePath:wavPath];
//    };
//    NSLog(@"touchesCancelled");
}

#pragma mark - 录音
//判断 录音权限
-(void)recordAuthor
{
    //授权
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioAuthStatus == AVAuthorizationStatusNotDetermined)
    {
        //第一次询问
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted){
            if (granted) {
                //同意授权,进行录音操作
//                [self recordMessage];
            }else{
                //不同意授权,提示用户
                [self showTipAlertWithButton];
            }
        }];
    }else if(audioAuthStatus == AVAuthorizationStatusRestricted || audioAuthStatus == AVAuthorizationStatusDenied ){
        //未授权
        [self showAlertViewWithButton];
    }else{
        //已授权
//        [self recordMessage];
    }
}

-(void)recordMessage
{
    [self stopVoiceAnimationing];
    [self stopPlay];
    self.recordTool = [RCTalkRecordTool sharedInstance];
    [self.recordTool startRecordVoice];
}

//暂时没用
-(void)sendMessage
{
    __weak typeof(self) weakSelf = self;
    self.recordTool.finishBlock = ^(NSString *wavPath,NSString *mp3Path, float recordTime){
        
        if (weakSelf.endState == 0) {
            //取消发送,删除录音文件
            [weakSelf.recordTool deletePath:wavPath];
        }else if (weakSelf.endState == 1){
            //发送
            if (recordTime < 1.0) {
                //取消发送,删除录音文件
                [weakSelf.recordTool deletePath:wavPath];
            }else{
                NSLog(@"wavPath ===>%@\n mp3Path===>%@",wavPath,mp3Path);
                [RCTalkRecordTool convertWavToMp3:wavPath withSavePath:mp3Path withBlock:^(NSString *errorInfo) {
//                    NSLog(@"T errorInfo ==> %@",errorInfo);
                    if (!errorInfo) {
                        NSLog(@"T errorInfo ==> %@",errorInfo);
                    }
                }];
                
                [weakSelf uploadOss:mp3Path];
            }
        }
    };
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    if (self.callMaskView.hidden) {
        return YES;
    }else
    {
        return NO;
    }
  
}

-(void)showTipAlertWithButton
{
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:@"您未开启麦克风不能进行录音操作" message:@"请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.talKView.userInteractionEnabled = NO;
    }];
    [tipAlert addAction:cancelAction];
    [self presentViewController:tipAlert animated:YES completion:nil];
}

-(void)showAlertViewWithButton
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"麦克风权限未开启" message:@"麦克风权限未开启,请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.talKView.userInteractionEnabled = NO;
    }];
    
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)stopTalkRecord
{
    self.recordTool = [RCTalkRecordTool sharedInstance];
    if (self.recordTool.savePath.length != 0) {
        [self.recordTool stopRecordVoice];
    }
    
    __weak typeof(self) weakSelf = self;
    //结束录音后会进入下面block
    self.recordTool.finishBlock = ^(NSString *wavPath,NSString *mp3Path, float recordTime){
        
        //定时器停止,销毁
        [weakSelf.recordTimer invalidate];
        weakSelf.recordTimer = nil;
        weakSelf.recordDuration = 0;
        
        if (weakSelf.endState == 0) {
            //取消发送,删除录音文件
            [weakSelf.recordTool deletePath:wavPath];
        }else if (weakSelf.endState == 1){
            //发送
            if (recordTime < 1.0) {
                //取消发送,删除录音文件
                [weakSelf.recordTool deletePath:wavPath];
            }else{
                NSLog(@"wavPath ===>%@\n mp3Path===>%@",wavPath,mp3Path);
                [RCTalkRecordTool convertWavToMp3:wavPath withSavePath:mp3Path withBlock:^(NSString *errorInfo) {

                    if (!errorInfo) {
                        NSLog(@"T errorInfo ==> %@",errorInfo);
                    }
                }];

                [weakSelf uploadOss:mp3Path];
            }
        }
    };
}

#pragma mark - 网络请求
-(void)uploadOss:(NSString *)filePath
{
    __weak typeof(self) weakSelf = self;
    [JDOSSUploadfileHandle uploadFile:filePath Callback:^(NSString * _Nonnull ossAdress) {
        NSLog(@"===>%@",ossAdress);
        if (ossAdress && ossAdress.length>1) {
            NSInteger time = [self getAudioDurationByUrl:ossAdress];
            NSInteger durationTime = time*1000;//单位:ms
            //发送消息
            [weakSelf sendMessageWithUrl:ossAdress messageType:MessageTypeVoice durationTime:durationTime];
        }else
        {
            [MBProgressHUD showError:@"发送失败"];
        }
    }];
//    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
//
//        FileUploadService *fileService = (FileUploadService *)httpInterface;
//        NSString *contentUrl = fileService.ossUrl;
//
//        NSInteger time = [self getAudioDurationByUrl:contentUrl];
//        NSInteger durationTime = time*1000;//单位:ms
//        //发送消息
//        [weakSelf sendMessageWithUrl:contentUrl messageType:MessageTypeVoice durationTime:durationTime];
////        [weakSelf TencentSendMessage:contentUrl withMessageType:MessageTypeVoice withDurationTime:durationTime];
//    };
//
//    void (^OnError) (NSInteger ,NSString *) = ^(NSInteger httpInterface, NSString *description){
//        NSLog(@"上传语音文件失败");
//    };
//
//    FileUploadService *fileService = [[FileUploadService alloc]initWithPath:filePath setOnSuccess:OnSuccess setOnError:OnError];
//    [fileService start];
}

-(void)sendMessageWithUrl:(NSString *)contentUrl messageType:(MessageType )messageType durationTime:(NSInteger)time
{

    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){

        NSLog(@"MessageToRobotService ==> OnSuccess");
    
//        [self updateMessageSelf:contentUrl withMessageType:messageType];
        [self updateMessageSelf:contentUrl withMessageType:messageType withDurationTime:time];
        
    };
    
    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){

        NSLog(@"MessageToRobotService ==> OnError");
        [MBProgressHUD showError:@"发送失败"];
//         [self showSystemHint:contentUrl withMessageType:messageType withDurationTime:time];
    };

//    NSString *content = @"http://xiaobuke.oss-cn-beijing.aliyuncs.com/story/20160316/11.mp3";
    NSLog(@"contentUrl:%@",contentUrl);
    NSLog(@"userToken:%@",APP_DELEGATE.mLoginResult.token);
    NSString *imtype = @"xbk:voicePlay";
//    MessageToRobotService *robotService = [[MessageToRobotService alloc]initWithUerToken:APP_DELEGATE.mLoginResult.token setContent:contentUrl setImtype:imtype setOnSuccess:OnSuccess setOnError:OnError];
    MessageToRobotService *robotService = [[MessageToRobotService alloc]initWithUerToken:APP_DELEGATE.mLoginResult.token setContent:contentUrl setImtype:imtype setTime:time setOnSuccess:OnSuccess setOnError:OnError];
    [robotService start];
}

#pragma mark - MusicPlayToolDelegate
-(void)endOfPlayAction
{
    NSLog(@"===> endOfPlayAction <===");
    [self stopVoiceAnimationing];
    self.mPlayingTalkMessageModel = nil;
}

#pragma mark - 动画相关
-(void)changeImage
{
    //更新测量值
    [self.recordTool.recorder updateMeters];
    
    float avg = [self.recordTool.recorder averagePowerForChannel:0];
    float minValue = -60;
    float range = 60;
    float outRange = 100;
    if (avg < minValue) {
        avg = minValue;
    }
    
    float decibels = (avg + range) / range * outRange;
    
    self.maskView.layer.frame = CGRectMake(0, self.yinjieImgView.frame.size.height - decibels * self.yinjieImgView.frame.size.height / 100, self.yinjieImgView.frame.size.width, self.yinjieImgView.frame.size.height);
    [self.yinjieImgView.layer setMask:self.maskView.layer];
}

-(void)updateTime
{
    self.recordDuration++;
    if (self.recordDuration >= Recording_Time - 1) {
        
        NSLog(@"录音自动结束");
        
        //停止动画
        [self stopRecordAnimation];
    }
}

-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString
{
    NSData *jsonData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    return dic;
}

//根据音频url 获取音频时长
-(NSInteger) getAudioDurationByUrl:(NSString *)string
{
//    NSString *mp3 = @"https://xiaobuke.oss-cn-beijing.aliyuncs.com/file/20180717153630.mp3";
    
//    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:[mp3 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:nil];
    
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:nil];
    CMTime audioDuration = audioAsset.duration;
    float durationSeconds = CMTimeGetSeconds(audioDuration);
    if (durationSeconds < 1) {
        durationSeconds = 1;
    }
    
    //ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    NSInteger time = ceilf(durationSeconds);
    
    NSLog(@"根据url获取音频时长===>%ld\n mp3URL--->%@",time,string);
    return time;
}

-(void)hiddenKeybord
{
    [self hideTalkKeybord];
}

//将时间戳转换成时间
-(NSString *)getMessageTimeByTimestamp:(NSString *)timestamp
{
    NSTimeInterval interval = [timestamp doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

//获取当前时间
-(NSString *)getCurrentTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *time = [formatter stringFromDate:date];
    
    NSLog(@"time:======> %@",time);
    return time;
}

-(BOOL)compareTimeWith:(NSString *)creatTimeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [formatter dateFromString:creatTimeStr];
    //得到与当前时间差
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    
    if (timeInterval < 60) {
        return NO;//1分钟之内不显示(两条消息相差时间)
    }
    
    return YES;
}

-(BOOL) compareTime:(NSString *)timeStr WithOtherTime:(NSString *)otherTimeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //时间一
    NSDate *time = [formatter dateFromString:timeStr];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:time];
    NSDate *date = [time dateByAddingTimeInterval:interval];
    
    //时间二
    NSDate *otherTime = [formatter dateFromString:otherTimeStr];
    NSTimeZone *otherZone = [NSTimeZone systemTimeZone];
    NSInteger otherInterval = [otherZone secondsFromGMTForDate:otherTime];
    NSDate *otherDate = [otherTime dateByAddingTimeInterval:otherInterval];
    
    //时间二与时间一的时间差
    double differ = [otherDate timeIntervalSinceReferenceDate] - [date timeIntervalSinceReferenceDate];
    int iTime = (int) differ;
    if (iTime < 60) {
        return YES;
    }else{
        return NO;
    }
}


//去除"-" ":" " "
-(NSString *)deleteSymbolWithString:(NSString *)string
{
    NSString *str;
    if ([string containsString:@"-"]) {
        str = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if ([str containsString:@":"]) {
            str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
            
        }
        if ([str containsString:@" "]) {
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        NSLog(@"str1---->%@",str);
    }
    
    return str;
}

//按时间排序
-(NSArray *)dateSortArray:(NSArray *)array
{
    
    NSArray *sortedArrray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        TalkMessageModel *model1 = obj1;
        TalkMessageModel *model2 = obj2;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSDate *date1 = [formatter dateFromString:model1.messageTime];
        NSDate *date2 = [formatter dateFromString:model2.messageTime];
        
        if (date1 == [date1 earlierDate:date2]) {
            return NSOrderedAscending;//升序
        }else if (date1 == [date1 laterDate:date2]){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
    }];
    return [NSArray arrayWithArray:sortedArrray];
}


//监听可变数组
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    __weak typeof(self) weakSelf = self;
    if ([keyPath isEqualToString:@"array"]) {
        
        if (self.observeObject.array.count > 0) {
           
            if (!self.hasMessage) {
                if ([self.view.subviews containsObject:self.talkPlaceHoderView]) {
                    [self.talkPlaceHoderView removeFromSuperview];
                }
                self.hasMessage = YES;
            }

            dispatch_async(dispatch_get_main_queue(), ^{

                [weakSelf.tableView reloadData];

                
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.observeObject.array.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//                if (self.tableView.contentSize.height>self.tableView.frame.size.height) {
//                    CGPoint offset = CGPointMake(0,self.tableView.contentSize.height-self.tableView.frame.size.height);
//                    [self.tableView setContentOffset:offset];
//                }
          
            });
        }
    }
    
    if ([keyPath isEqualToString:@"hidden"]) {
        if (self.forbidBlock) {
            self.forbidBlock(self.callMaskView.hidden);
        }
    }
}

@end
