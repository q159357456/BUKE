//
//  HomeViewController.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//
#import "HomeViewController.h"
#import "MyCenterView.h"
#import "StoryView.h"
#import "XYDMStoryView.h"
#import "EnglishView.h"
#import "BookListViewController.h"
#import "XG_PushManager.h"
#import "TallkNotificationController.h"
#import "BabyInfoViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RCIMTokenService.h"
#import "CustomVoiceMessage.h"
#import "MBProgressHUD+XBK.h"
#import "GetUpdateSoftwareInfoService.h"
#import "BabyRobotInfo.h"
#import "TalkMessageModel.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceUserInfo.h"
#import "EmojiObject.h"
#import "PushDeviceTokenService.h"
#import "DataBaseTool.h"
#import "OJTabView.h"
#import "MiniBuKe-Swift.h"
#import "BKCenterView_New.h"
#import "UIResponder+Event.h"
#import "CommonUsePackaging.h"
#import "ARLockView.h"
#import "ARRecognitionView.h"
#import "XYDMSetting.h"
#define TOP_HEIGHT kNavbarH
#define BOTTOM_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height>=44?84:50)
#define CUSTOM_MESSAGETYPE  @"xbk:voicePlay"
#define UPDATE_MY_CENTER_DATA @"UPDATE_MY_CENTER_DATA"

#import "BKPictureBookPage.h"
#import "BookneededScanningCodeVC.h"
#import "BKNewLoginController.h"
#import "BabyInfoAddController.h"
#import "FetchBabyInfoService.h"
#import "BKHomePopUpTipCtr.h"
#import "BKCustomWebViewCtr.h"
#import "IntensiveReadingController.h"
#import "BKCustomSearchView.h"
#import "BKSearchController.h"
#import "TencentIMManager.h"
#import "BKBabyCareMainCtr.h"
#import "BKCameraManager.h"
#import "ARDownFlieManager.h"
#import "ARReportUpLoadManager.h"
@interface HomeViewController ()<RCIMClientReceiveMessageDelegate,RCConnectionStatusChangeDelegate,Goto_Record_delegate>
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIButton *myCenterButton;
@property(nonatomic,strong) UIButton *pictureBookButton;
@property(nonatomic,strong) UIButton *storyButton;
@property(nonatomic,strong) UIButton *moveButton;//宝贝信息按钮
@property(nonatomic,strong) UIButton *msgButton;//消息中心
//扫一扫入口
@property(nonatomic,strong) UIButton *scanButton;

@property(nonatomic,strong) BKPictureBookPage *pictureBookView;
@property(nonatomic,strong) BKCenterView_New *myCenterView;
@property(nonatomic,strong) XYDMStoryView *storyView;
@property(nonatomic,strong) EnglishView *englishView;

//@property (nonatomic) TabIndex currentTabIndex;

@property(nonatomic, strong)NSMutableArray *messageArray;
@property(nonatomic,strong) NSArray *emojiArray;

@property(nonatomic,strong) OJTabView *tabView1;
@property(nonatomic,strong) OJTabView *tabView2;
@property(nonatomic,strong) OJTabView *tabView3;
@property(nonatomic,strong) OJTabView *tabView4;

@end

@implementation HomeViewController
-(NSArray *)emojiArray
{
    if (!_emojiArray) {
        _emojiArray = [[CommonUsePackaging shareInstance] emojiArray];
    }
    
    return _emojiArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //清除消息角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //注册监听自定义通知
    [self registerCustomNotic];
    [self onPushDeviceTokenService];
    _currentTabIndex = TabIndex_pictureBookView;
    self.messageArray = [NSMutableArray array];
    
    [self initView];
    //检查更新
    [self onGetUpdateSoftwareInfoService];
    //拉取信鸽未收到的消息
    [XG_PushManager pullNotifacationData];
    //启动腾讯IM
//    if (APP_DELEGATE.mLoginResult.SN) {
//        [[TencentIMManager defautManager] loginIn];
//    }
   
    [MBProgressHUD hideHUD];
    //判断宝贝信息是否填写(没填写弹框);
    
    if (APP_DELEGATE.mLoginResult != nil) {
        BOOL hasbaybyinfo = [APP_DELEGATE.mLoginResult.hasBabyInfo boolValue];
        BOOL is_first = [APP_DELEGATE isShowPromptEnterSexInfoWindow];
        BOOL has_jumped = [[NSUserDefaults standardUserDefaults] boolForKey:@"HasJumped"];
        if (!hasbaybyinfo && (!is_first && !has_jumped)) {
            OldUserRemindView *oldmin = [[OldUserRemindView alloc]initWithFrame:self.view.bounds];
            oldmin.delegate = self;
            [APP_DELEGATE.window  addSubview:oldmin];
            [APP_DELEGATE setPromptEnterSexInfoWindowFlag:YES];

        }
    }
    [self checkTheActionPOP];
    //上报历史数据
    [ARReportUpLoadManager uploadReport];
}

#pragma mark - Goto_Record_delegate
-(void)Goto_Record
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"OLD_REMIND"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    OJSexChooseController *sexChooseVC = [[OJSexChooseController alloc] init];
    [self.navigationController pushViewController:sexChooseVC animated:YES];
}

-(void)onGetUpdateSoftwareInfoService
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"GetUpdateSoftwareInfoService ==> OnSuccess");
        GetUpdateSoftwareInfoService *service = (GetUpdateSoftwareInfoService*)httpInterface;
        
        if (service.mVersionInfo != nil) {
            
            VersionUpdateType mVersionUpdateType = [service.mVersionInfo getVersionUpdateType:version];//@"1.2.6"];
//            VersionUpdateTypeForce,
//            VersionUpdateTypeGray,
//            VersionUpdateTypeRecommend
            switch (mVersionUpdateType) {
                case VersionUpdateTypeForce:
                {
                    NSLog(@"VersionUpdateType => 强制更新");
                    [self initPromptView:service.mVersionInfo setVersionUpdateType:mVersionUpdateType];
                    
                    APP_DELEGATE.mVersionInfo = service.mVersionInfo;
                    
                    if (self.customDelegate != nil) {
                        [self.customDelegate updateVersion];
                    }
                }
                    break;
                case VersionUpdateTypeGray:
                {
                    NSLog(@"VersionUpdateType => 灰度更新");
                    [self initPromptView:service.mVersionInfo setVersionUpdateType:mVersionUpdateType];
                    
                    APP_DELEGATE.mVersionInfo = service.mVersionInfo;
                    
                    if (self.customDelegate != nil) {
                        [self.customDelegate updateVersion];
                    }
                }
                    break;
                case VersionUpdateTypeRecommend:
                {
                    NSLog(@"VersionUpdateType => 推荐更新");
                    
                    APP_DELEGATE.mVersionInfo = service.mVersionInfo;
                    
                    if (self.customDelegate != nil) {
                        [self.customDelegate updateVersion];
                    }
                }
                    break;
                default:
                    break;
            }
            
        }
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"GetUpdateSoftwareInfoService ==> OnError");
    };
    
    GetUpdateSoftwareInfoService *service = [[GetUpdateSoftwareInfoService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setUserId:APP_DELEGATE.mLoginResult.userId
        setVersionNumber:version];
    [service start];
}

-(void)onPushDeviceTokenService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"PushDeviceTokenService ==> OnSuccess");
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"PushDeviceTokenService ==> OnError");
        
    };
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    if (deviceToken == nil) {
        deviceToken = @"";
    }
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:APP_DELEGATE.mLoginResult.userId forKey:@"userId"];
    [paramsDic setObject:deviceToken forKey:@"deviceToken"];
    [paramsDic setObject:version forKey:@"appVersion"];
    [paramsDic setObject:@"ios" forKey:@"platform"];
    [paramsDic setObject:phoneVersion forKey:@"platformVersion"];
    
    PushDeviceTokenService *service = [[PushDeviceTokenService alloc] initWithOnSuccess:OnSuccess setOnError:OnError setDictionary:paramsDic];
    [service start];
}

-(void) initPromptView:(VersionInfo *) mVersionInfo setVersionUpdateType:(VersionUpdateType) mVersionUpdateType
{
    switch (mVersionUpdateType) {
        case VersionUpdateTypeForce:{//强制弹窗
            BKHomePopUpTipCtr *ctr = [[BKHomePopUpTipCtr alloc]init];
            [ctr showWithTitle:@"发现新版本" andsubTitle:[NSString stringWithFormat:@"V%@",mVersionInfo.version] andBtntitel:@"立即升级" andContent:mVersionInfo.mDescription andImageName:@"home_tip_topicon" andIsTap:NO andIsFullPic:NO AndBtnAction:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mVersionInfo.path]];
            }];
            [ctr startShowTipWithController:self];
        }
            break;
        case VersionUpdateTypeGray:{//灰度弹窗
            NSInteger count = 0;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"VersionUpdateTypeGray-V%@",mVersionInfo.version]] != nil) {
                 count = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"VersionUpdateTypeGray-V%@",mVersionInfo.version]] integerValue];
                if (count >= 2) {
                    return;
                }
            }
            BKHomePopUpTipCtr *ctr = [[BKHomePopUpTipCtr alloc]init];
            [ctr showWithTitle:@"发现新版本" andsubTitle:[NSString stringWithFormat:@"V%@",mVersionInfo.version] andBtntitel:@"立即升级" andContent:mVersionInfo.mDescription andImageName:@"home_tip_topicon" andIsTap:YES andIsFullPic:NO AndBtnAction:^{
                [ctr dissMissCtr];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mVersionInfo.path]];
            }];
            [ctr startShowTipWithController:self];
            //本地记录弹窗次数
            [[NSUserDefaults standardUserDefaults] setObject:@(count+1) forKey:[NSString stringWithFormat:@"VersionUpdateTypeGray-V%@",mVersionInfo.version]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self onRCIMTokenService];
    //        融云监听
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];
    //注册自定义消息类型
    [[RCIMClient sharedRCIMClient] registerMessageType:[CustomVoiceMessage class]];
    
    [self hideBarStyle];
    [self chooseTabView];
    
    //获取宝贝信息
    [self getBabyInfo];
    if (self.currentTabIndex == TabIndex_EnglishView) {
        if (self.englishView) {
            [ARAudioManager singleton].isViewWillApear = YES;
            [ARAudioManager singleton].InEasyAR_Working = YES;
            [self.englishView restart];
        }
    }
    
    //babycare 保持连线
    if(APP_DELEGATE.snData && [APP_DELEGATE.snData.type integerValue] == 4){
        if ([BKCameraManager shareInstance].deviceState != DeviceContentStateType_onLine) {
            [[BKCameraManager shareInstance] ConnectDevice];
        }
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self onPushDeviceTokenService];
    [MBProgressHUD hideHUD];
    //腾讯Im新消息通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReceiveTencentMessage:) name:TENCENTIMMESSAGE object:nil];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
    //移除腾讯Im新消息通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:TENCENTIMMESSAGE object:nil];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }

}

-(void) bindNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyCenterData) name:UPDATE_MY_CENTER_DATA object:nil];
}

-(void) unbindNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:UPDATE_MY_CENTER_DATA];
}

-(void) updateMyCenterData
{
    NSLog(@"===> updateMyCenterData <===");
}

- (void) chooseTabView {
    
    switch (_currentTabIndex) {
        case TabIndex_pictureBookView:
        {
            if (_pictureBookView == nil) {
                  _pictureBookView = [[BKPictureBookPage alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - TOP_HEIGHT - BOTTOM_HEIGHT)];
                [_middleView addSubview:_pictureBookView];
                _pictureBookView.hidden = YES;
            }
            
            _pictureBookView.hidden = NO;
            _myCenterView.hidden = YES;
            _storyView.hidden = YES;
            _englishView.hidden = YES;
            _scanButton.hidden = NO;
            
            [_storyButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
            [_myCenterButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];

            [_pictureBookButton setTitleColor:COLOR_STRING(@"#FFFFFF") forState:UIControlStateNormal];
            
//            [MobClick event:EVENT_TAB_BOOK_3];
            [[BaiduMobStat defaultStat] logEvent:@"c_tabbar100" eventLabel:@"绘本"];
            
        }
            break;
        case TabIndex_EnglishView:
        {
            
            if (_englishView == nil) {
                    _englishView = [[EnglishView alloc] initWithFrame:CGRectMake(0,-20,self.view.frame.size.width, self.view.frame.size.height + 20 - BOTTOM_HEIGHT)];
                }
            [self.view addSubview:_englishView];
                _englishView.hidden = YES;
            
            _pictureBookView.hidden = YES;
            _myCenterView.hidden = YES;
            _storyView.hidden = YES;
            _englishView.hidden = NO;
            _scanButton.hidden = YES;
            
            [_storyButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
            [_myCenterButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
            
            [_pictureBookButton setTitleColor:COLOR_STRING(@"#FFFFFF") forState:UIControlStateNormal];
            
            [[BaiduMobStat defaultStat] logEvent:@"c_tabbar100" eventLabel:@"英语"];

        }
            break;
        case TabIndex_myCenterView:
        {
            if (_myCenterView == nil) {
                _myCenterView = [[BKCenterView_New alloc] initWithFrame:CGRectMake(0,-20,self.view.frame.size.width, self.view.frame.size.height + 20 - BOTTOM_HEIGHT)];
                [self.view addSubview:_myCenterView];
                _myCenterView.messageArray = self.messageArray;
                [_myCenterView reload];
                _myCenterView.hidden = YES;
            } else {
                _myCenterView.messageArray = self.messageArray;
                [_myCenterView reload];
            }
            
            _pictureBookView.hidden = YES;
            _myCenterView.hidden = NO;
            _storyView.hidden = YES;
            _englishView.hidden = YES;
            _scanButton.hidden = YES;

            [_pictureBookButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
            [_storyButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
            
            [_myCenterButton setTitleColor:COLOR_STRING(@"#FFFFFF") forState:UIControlStateNormal];
            
//            [MobClick event:EVENT_TAB_MY_5];
            [[BaiduMobStat defaultStat] logEvent:@"c_tabbar100" eventLabel:@"我的"];

        }
            break;
        case TabIndex_storyView:
        {
            if (_storyView == nil) {
                _storyView = [[XYDMStoryView alloc] initWithFrame:CGRectMake(0,-20,self.view.frame.size.width, self.view.frame.size.height + 20 - BOTTOM_HEIGHT)];
                [self.view addSubview:_storyView];
                [_storyView addXMLY];
//                _storyView = [[StoryView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - TOP_HEIGHT - BOTTOM_HEIGHT)];
//                 [_middleView addSubview:_storyView];

            }
            _pictureBookView.hidden = YES;
            _myCenterView.hidden = YES;
            _storyView.hidden = NO;
            _englishView.hidden = YES;
            _scanButton.hidden = NO;
            [_pictureBookButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
            [_myCenterButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
            [_storyButton setTitleColor:COLOR_STRING(@"#FFFFFF") forState:UIControlStateNormal];

            [[BaiduMobStat defaultStat] logEvent:@"c_tabbar100" eventLabel:@"听听"];

        }
            break;
            
        default:
            break;
    }
    
}

- (void)initView{
    _topView = [[UIView alloc] init];
    [_topView setBackgroundColor:[UIColor whiteColor] ];
    _middleView = [[UIView alloc] init];
    _bottomView = [[UIView alloc] init];
    [_bottomView setBackgroundColor:COLOR_STRING(@"#FAFAFA")];
    
    [self.view addSubview:_topView];
    [self.view addSubview:_middleView];
    [self.view addSubview:_bottomView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, TOP_HEIGHT));
        make.top.equalTo(self.view);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width,BOTTOM_HEIGHT));
        make.top.equalTo(self.view).with.offset(self.view.frame.size.height - BOTTOM_HEIGHT);
        make.bottom.equalTo(self.view);
    }];
    
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    
    [self createTopViewChild];
    [self createBottomViewChild];
}

- (void)createBottomViewChild{
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, -4, self.view.frame.size.width, 5)];
    lineImageView.image = [UIImage imageNamed:@"tab_bg line"];
    [_bottomView addSubview:lineImageView];
    self.tabView1 = [[OJTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4, BOTTOM_HEIGHT) setTitle:@"绘本"  setDefaultIcon:@"icon_tab_book_default" setPressIcon:@"icon_tab_book_press" setOnTabClick:^{
            [self pictureBookButtonClick:NULL];
        }];
        [_bottomView addSubview:self.tabView1];
        [self.tabView1 setTabClickStatus:true];
    
    self.tabView2 = [[OJTabView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/4, BOTTOM_HEIGHT) setTitle:@"伴读" setDefaultIcon:@"icon_tab_english_default" setPressIcon:@"icon_tab_english_press" setOnTabClick:^{
            NSLog(@"click book tab");
            [self englishButtonClick:NULL];
        }];
        [_bottomView addSubview:self.tabView2];
//        [self.tabView2 setTabClickStatus:true];
    self.tabView3 = [[OJTabView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*2/4,0, self.view.frame.size.width/4, BOTTOM_HEIGHT) setTitle:@"听听" setDefaultIcon:@"icon_tab_listento_default" setPressIcon:@"icon_tab_listento_press" setOnTabClick:^{
            NSLog(@"click listento tab");
            [self storyButtonClick:NULL];
        }];
        [_bottomView addSubview:self.tabView3];
    
    self.tabView4 = [[OJTabView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4 * 3,0, self.view.frame.size.width/4, BOTTOM_HEIGHT) setTitle:@"我的" setDefaultIcon:@"icon_tab_my_default" setPressIcon:@"icon_tab_my_press" setOnTabClick:^{
            NSLog(@"click my tab");
            [self myCenterButtonClick:NULL];
        }];
        [_bottomView addSubview:self.tabView4];

}

- (void)createMiddleViewChild{

    _pictureBookView = [[BKPictureBookPage alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - TOP_HEIGHT - BOTTOM_HEIGHT)];
    
    [_middleView addSubview:_pictureBookView];
    
    _myCenterView = [[BKCenterView_New alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - TOP_HEIGHT - BOTTOM_HEIGHT)];
    [_middleView addSubview:_myCenterView];
    
    _storyView = [[StoryView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - TOP_HEIGHT - BOTTOM_HEIGHT)];
    [_middleView addSubview:_storyView];
    
//        _englishView = [[EnglishView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - TOP_HEIGHT - BOTTOM_HEIGHT)];
//        [_middleView addSubview:_englishView];
    
    _pictureBookView.hidden = YES;
    _myCenterView.hidden = YES;
    _storyView.hidden = YES;
    _englishView.hidden = YES;
}

- (void)createTopViewChild{
    _myCenterButton = [[UIButton alloc] init];
    [_myCenterButton setTitle:@"我的" forState:UIControlStateNormal];
    [_myCenterButton.titleLabel setFont:MY_FONT(18)];
    [_myCenterButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
    [_myCenterButton addTarget:self action:@selector(myCenterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_myCenterButton];
    _myCenterButton.hidden = YES;
    
    _pictureBookButton = [[UIButton alloc] init];
    [_pictureBookButton setTitle:@"绘本" forState:UIControlStateNormal];
    [_pictureBookButton.titleLabel setFont:MY_FONT(18)];
    [_pictureBookButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
    [_pictureBookButton addTarget:self action:@selector(pictureBookButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_pictureBookButton];
    _pictureBookButton.hidden = YES;
    
    _storyButton = [[UIButton alloc] init];
    [_storyButton setTitle:@"听听" forState:UIControlStateNormal];
    [_storyButton.titleLabel setFont:MY_FONT(18)];
    [_storyButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
    
    [_storyButton addTarget:self action:@selector(storyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_storyButton];
    _storyButton.hidden = YES;
    
    _moveButton = [[UIButton alloc] init];
    [_moveButton setImage:[UIImage imageNamed:@"id_image_default boy"] forState:UIControlStateNormal];
    [_moveButton setImage:[UIImage imageNamed:@"id_image_default boy"] forState:UIControlStateSelected];
    [_moveButton.titleLabel setFont:MY_FONT(18)];
    [_moveButton setAdjustsImageWhenHighlighted:NO];
    _moveButton.layer.cornerRadius = 29.f*0.5;
    _moveButton.clipsToBounds = YES;
    [_moveButton addTarget:self action:@selector(moveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_moveButton];

    _msgButton = [[UIButton alloc] init];
    [_msgButton.titleLabel setFont:MY_FONT(18)];
    [_msgButton setImage:[UIImage imageNamed:@"home_mes_norl"] forState:UIControlStateSelected];
    [_msgButton setImage:[UIImage imageNamed:@"home_mes_norl"] forState:UIControlStateNormal];
    [_msgButton addTarget:self action:@selector(msgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_msgButton setAdjustsImageWhenHighlighted:NO];
    [_topView addSubview:_msgButton];
    
    _scanButton = [[UIButton alloc]init];
    [_scanButton setImage:[UIImage imageNamed:@"home_scane"] forState:UIControlStateSelected];
    [_scanButton setImage:[UIImage imageNamed:@"home_scane"] forState:UIControlStateNormal];
    [_scanButton addTarget:self action:@selector(ScanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scanButton setAdjustsImageWhenHighlighted:NO];
    [_topView addSubview:_scanButton];
    
    BKCustomSearchView *searchView = [[BKCustomSearchView alloc]initWithFrame:CGRectMake(0, 0, 222, 32)];
    [_topView addSubview:searchView];
    UIButton *searchBtn = [[UIButton alloc]init];
    [searchBtn addTarget:self action:@selector(searchClickAction) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    CGSize buttonSize = CGSizeMake(60, 35);
    
    [_pictureBookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.top.equalTo(_topView).with.offset(37);
        make.centerX.mas_equalTo(_topView.mas_centerX).with.mas_offset(-55);
    }];
    
    [_storyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.top.equalTo(_topView).with.offset(37);
        make.centerX.mas_equalTo(_topView.mas_centerX);
    }];
    
    [_myCenterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.top.equalTo(_topView).with.offset(37);
        make.centerX.mas_equalTo(_topView.mas_centerX).with.mas_offset(55);
    }];
    
    [_moveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(29, 29));
        make.top.equalTo(_topView).with.offset(kNavbarH-44.f+9.f);
        make.left.equalTo(_topView).with.offset(17);
    }];
    
    [_msgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(_topView).with.offset(-7);
        make.centerY.mas_equalTo(_moveButton.mas_centerY).with.offset(0);
    }];
    
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(_msgButton.mas_left).with.offset(4);
        make.centerY.equalTo(_msgButton.mas_centerY).offset(0);
    }];
    
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32.f);
        make.centerY.equalTo(_moveButton.mas_centerY).offset(0);
        make.left.equalTo(_moveButton.mas_right).offset(19.f);
        make.right.equalTo(_scanButton.mas_left).offset(-7);
    }];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_left).offset(20);
        make.right.equalTo(searchView.mas_right).offset(0);
        make.top.equalTo(searchView.mas_top);
        make.bottom.equalTo(searchView.mas_bottom);
    }];
}

//跳转消息中心
-(IBAction)msgButtonClick:(id)sender{
    //去除气泡
    [self changeTheMesIcon:YES];

    TallkNotificationController *vc= [[TallkNotificationController alloc]init];
    vc.observeArray = [NSArray arrayWithArray:self.messageArray];
    [self.navigationController pushViewController:vc animated:YES];
//    [MobClick event:EVENT_TALK_6];
    
    [[BaiduMobStat defaultStat] logEvent:@"c_mscr100" eventLabel:@"绘本首页"];
}

-(IBAction)myCenterButtonClick:(id)sender{
    NSLog(@"我的");
   
    if (_currentTabIndex == TabIndex_EnglishView && [ARAudioManager singleton].isRead) {
        [self.tabView4 setTabClickStatus:false];
        [self.tabView2 setTabClickStatus:true];
        [ARLockView showLockInfoCallBack:^{
            _currentTabIndex = TabIndex_myCenterView;
            [self chooseTabView];
            [self.tabView4 setTabClickStatus:true];
            [self.tabView2 setTabClickStatus:false];
        }];
    }else
    {
        
        _currentTabIndex = TabIndex_myCenterView;
        [self chooseTabView];
        [ARLockView stopAR];
    }
}

-(IBAction)pictureBookButtonClick:(id)sender{
    NSLog(@"绘本");
    if (_currentTabIndex == TabIndex_EnglishView && [ARAudioManager singleton].isRead) {
        [self.tabView1 setTabClickStatus:false];
        [self.tabView2 setTabClickStatus:true];
        [ARLockView showLockInfoCallBack:^{
            _currentTabIndex = TabIndex_pictureBookView;
            [self chooseTabView];
            [self.tabView1 setTabClickStatus:true];
            [self.tabView2 setTabClickStatus:false];
        }];
    }else
    {
        
        _currentTabIndex = TabIndex_pictureBookView;
        [self chooseTabView];
        [ARLockView stopAR];
    }
}

-(IBAction)storyButtonClick:(id)sender{
    NSLog(@"故事");
    if (_currentTabIndex == TabIndex_EnglishView && [ARAudioManager singleton].isRead) {
        [self.tabView3 setTabClickStatus:false];
        [self.tabView2 setTabClickStatus:true];
        [ARLockView showLockInfoCallBack:^{
            _currentTabIndex = TabIndex_storyView;
            [self chooseTabView];
            [self.tabView3 setTabClickStatus:true];
            [self.tabView2 setTabClickStatus:false];
        }];
    }else
    {
        
        _currentTabIndex = TabIndex_storyView;
        [self chooseTabView];
        [ARLockView stopAR];
    }
}

-(IBAction)moveButtonClick:(id)sender{
    NSLog(@"更多");
    //跳转宝贝信息
    BabyInfoAddController *vc= [[BabyInfoAddController alloc]init];
//    [MobClick event:EVENT_BABY_INFO_9];
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    [[BaiduMobStat defaultStat] logEvent:@"c_baInfo100" eventLabel:@"绘本首页"];
}
-(IBAction)englishButtonClick:(id)sender{
    //英语
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor clearColor];
    }
    if (_englishView) {
        [ARAudioManager singleton].InEasyAR_Working = YES;
        [_englishView  restart];
    }
    _currentTabIndex = TabIndex_EnglishView;
    [self chooseTabView];
}
#pragma mark - 扫一扫
-(void)ScanButtonClick:(UIButton*)btn{

    BookneededScanningCodeVC *mTeachingMaterialViewController = [[BookneededScanningCodeVC alloc] init];
    [APP_DELEGATE.navigationController pushViewController:mTeachingMaterialViewController animated:YES];
    return;
}
#pragma mark - 搜索入口
- (void)searchClickAction{
    BKSearchController *ctr = [[BKSearchController alloc]init];
    [APP_DELEGATE.navigationController pushViewController:ctr animated:NO];
}
#pragma mark - 融云服务器
-(void)onRCIMTokenService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"RCIMTokenService ==> OnSuccess");

        RCIMTokenService *service = (RCIMTokenService *)httpInterface;
        if (service.RCtoken != nil) {
            //集成融云服务器
            [[RCIMClient sharedRCIMClient] connectWithToken:service.RCtoken success:^(NSString *userId) {
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            } error:^(RCConnectErrorCode status) {
                NSLog(@"登陆的错误码为:%ld", (long)status);
            } tokenIncorrect:^{
                NSLog(@"token错误");
            }];
        }
    };

    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"RCIMTokenService ==> OnError");
    };

    NSString *userName = APP_DELEGATE.mLoginResult.userName;
    NSString *userAvatar = APP_DELEGATE.mLoginResult.imageUlr;
    NSString *userId = APP_DELEGATE.mLoginResult.userId;

    RCIMTokenService *tokenService = [[RCIMTokenService alloc]init:userId setUserName:userName setUserAvatar:userAvatar setOnSuccess:OnSuccess setOnError:OnError];
    tokenService.isPostRequestMethod = YES;
    [tokenService start];
}

#pragma mark - RCIMClientReceiveMessageDelegate

-(void)onConnectionStatusChanged:(RCConnectionStatus)status
{
    switch (status) {
        case ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT:
        {
            NSLog(@"用户在其他设备上登录");
            [MBProgressHUD showText:@"用户在其他设备上登录"];
            
            [APP_DELEGATE removeLoginResult];

//            UserLoginViewController *LoginController = [[UserLoginViewController alloc] init];
//            [APP_DELEGATE.navigationController pushViewController:LoginController animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                BKNewLoginController *LoginController = [[BKNewLoginController alloc]init];
                APP_DELEGATE.navigationController = [[BKNavgationController alloc] initWithRootViewController:LoginController];
                APP_DELEGATE.window.rootViewController = APP_DELEGATE.navigationController;
                [[ARRecognitionView singleton] stopARAndAnimation];
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

    //绑定时间戳
    NSString *bandingTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Banding_Timestamp"];

    if (bandingTimeStr.length > 0 && bandingTimeStr != nil) {
        long long bandingTime = [bandingTimeStr integerValue];

//        NSLog(@"bandingTime === %lld, message.sentTime=== %lld",bandingTime,message.sentTime);

        if (bandingTime > message.sentTime) {
            return;
        }
    }

    //先判断消息类型
    if ([message.objectName isEqualToString:CUSTOM_MESSAGETYPE]){
        //改变气泡
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.popView.hidden = NO;
            if (APP_DELEGATE.mLoginResult.SN.length>0) {
                [self changeTheMesIcon:NO];
                [CommonUsePackaging shareInstance].isShuoShuoListNoticeRemind = YES;
            }
            
        });

        if ([message.content isMemberOfClass:[CustomVoiceMessage class]]){
            CustomVoiceMessage *voiceMsg = (CustomVoiceMessage *)message.content;

            NSString *receivedTime = [NSString stringWithFormat:@"%lld",message.sentTime];

            NSString *urlStr = nil;
            if (voiceMsg.voice != nil && voiceMsg.voice.length != 0 && ![voiceMsg.voice isEqualToString:@""]) {
                urlStr = voiceMsg.voice;
            }

            if (voiceMsg.extra != nil && voiceMsg.extra.length != 0 && ![voiceMsg.extra isEqualToString:@""]){
                NSDictionary *dic = [self parseJSONStringToNSDictionary:voiceMsg.extra];
                NSLog(@"解析后的字典:%@",dic);

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

-(void)updateRobotMessage:(BabyRobotInfo *)babyInfo voiceUrl:(NSString *)urlStr timestamp:(NSString *)timestamp
{
    NSString *messageTime = [self getMessageTimeByTimestamp:timestamp];

    TalkMessageModel *model = [[TalkMessageModel alloc] init];
    model.messageType = MessageTypeVoice;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageReadStatus = MessageReadStatusUnRead;
    model.showNickName = YES;
    model.mId = 0;
    model.logoUrl = @"";//babyInfo.babyImageUrl;
//    model.showMessageTime = YES;
    model.messageTime = messageTime;
    if (self.messageArray == nil || self.messageArray.count == 0) {
        model.showMessageTime = YES;
        model.messageTime = messageTime;
    }else{
        TalkMessageModel *lastModel = [self.messageArray lastObject];
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
        model.duringTime = [self getAudioDurationByUrl:urlStr];
        model.voiceUrl = urlStr;
    }

//    [self.messageArray addObject:model];
    //缓存数据库
    [DataBaseTool addMessageModel:model];
}

-(void)updateMessageOther:(VoiceUserInfo *)info voiceUrl:(NSString *)urlStr timestamp:(NSString *)timestamp
{
    NSString *messageTime = [self getMessageTimeByTimestamp:timestamp];

    TalkMessageModel *model = [[TalkMessageModel alloc]init];
    model.messageSenderType = MessageSenderTypeOther;
    model.messageReadStatus = MessageReadStatusUnRead;
    model.showNickName = YES;
    model.mId = 0;
    model.logoUrl = info.imageUrl;
    model.messageType = MessageTypeVoice;
//    model.showMessageTime = YES;
    model.messageTime = messageTime;

    if (info.appellativeName.length > 0) {
        model.nickName = info.appellativeName;
    }else{
        if (info.nickName.length > 0) {
            model.nickName = info.nickName;
        }
        else{
            model.nickName = info.userName;
        }
    }
    if (self.messageArray == nil || self.messageArray.count == 0) {
        model.showMessageTime = YES;
        model.messageTime = messageTime;
    }else{

        TalkMessageModel *lastModel = [self.messageArray lastObject];
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
        model.duringTime = [self getAudioDurationByUrl:urlStr];
        model.voiceUrl = urlStr;
    }

//    [self.messageArray addObject:model];
    //缓存数据库
    [DataBaseTool addMessageModel:model];
}

-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString
{
    NSData *jsonData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    return dic;
}

//根据音频url 获取音频时长
-(float) getAudioDurationByUrl:(NSString *)string
{
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:nil];
    CMTime audioDuration = audioAsset.duration;
    float durationSeconds = CMTimeGetSeconds(audioDuration);
    
    return durationSeconds;
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
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
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

- (void)hideBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor clearColor];
    }
}

- (void)showBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor clearColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}
#pragma mark - c改变消息图标
-(void)changeTheMesIcon:(BOOL)ishide{
    if (ishide) {
        [_msgButton setImage:[UIImage imageNamed:@"home_mes_norl"] forState:UIControlStateSelected];
        [_msgButton setImage:[UIImage imageNamed:@"home_mes_norl"] forState:UIControlStateNormal];
        [CommonUsePackaging shareInstance].isHadNoticeRemind = NO;
        if (_myCenterView) {
            
            [_myCenterView.centerHeaderView.newsButton setImage:[UIImage imageNamed:@"news_small_blace"] forState:UIControlStateNormal];
            
        }
    }else{
        [_msgButton setImage:[UIImage imageNamed:@"home_mes_selet"] forState:UIControlStateSelected];
        [_msgButton setImage:[UIImage imageNamed:@"home_mes_selet"] forState:UIControlStateNormal];
        [CommonUsePackaging shareInstance].isHadNoticeRemind = YES;
        if (_myCenterView) {
        
             [_myCenterView.centerHeaderView.newsButton setImage:[UIImage imageNamed:@"news_small_black_yes"] forState:UIControlStateNormal];
        }
    }
}
#pragma mark - 获取宝贝信息
-(void)getBabyInfo
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface, NSString *description){
        NSLog(@"FetchBabyInfoService===>OnSuccess");
        FetchBabyInfoService *service = (FetchBabyInfoService *)httpInterface;
        NSDictionary *babyDic = service.babyDic;
        if (babyDic != nil) {
            BabyRobotInfo *babyInfo = [BabyRobotInfo parseDataByDictionary:babyDic];
//            if (babyInfo.babyNickName.length) {
//                self.badyNameTitle.text = babyInfo.babyNickName;
//            }else{
//                self.badyNameTitle.text = @"宝贝";
//            }
            if (babyInfo.babyImageUrl.length) {
                [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:[babyInfo.babyImageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]  options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (image != nil) {
                        [self.moveButton setImage:image forState:UIControlStateNormal];
                        [self.moveButton setImage:image forState:UIControlStateSelected];
                    }else{
                        if (babyInfo.babyGender) {
                            [self.moveButton setImage:[UIImage imageNamed:@"baby_default image_girl"] forState:UIControlStateNormal];
                            [self.moveButton setImage:[UIImage imageNamed:@"baby_default image_girl"] forState:UIControlStateSelected];
                        }else{
                            [self.moveButton setImage:[UIImage imageNamed:@"id_image_default boy"] forState:UIControlStateNormal];
                            [self.moveButton setImage:[UIImage imageNamed:@"id_image_default boy"] forState:UIControlStateSelected];                }
                    }
                }];
            }else{
                if (babyInfo.babyGender) {
                    [self.moveButton setImage:[UIImage imageNamed:@"baby_default image_girl"] forState:UIControlStateNormal];
                    [self.moveButton setImage:[UIImage imageNamed:@"baby_default image_girl"] forState:UIControlStateSelected];
                }else{
                    [self.moveButton setImage:[UIImage imageNamed:@"id_image_default boy"] forState:UIControlStateNormal];
                    [self.moveButton setImage:[UIImage imageNamed:@"id_image_default boy"] forState:UIControlStateSelected];                }
            }
        }
    };
    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"FetchBabyInfoService===>OnError");
        NSLog(@"FetchBabyInfoService--->%@",description);
    };
    FetchBabyInfoService *babyService = [[FetchBabyInfoService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
    [babyService start];
}

#pragma mark - PUSHNoticAction
- (void)registerCustomNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushHomePopupAction:) name:PushNoticHomePOP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessageNotComing) name:PushNoticComing object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessageClickJump:) name:PushClickJump object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClearRedPoint:) name:PushBackClearRedPoint object:nil];
    
}
-(void)ReceiveTencentMessage:(NSNotification*)notif
{
    [self changeTheMesIcon:NO];
    //    NSArray *array =(NSArray*)notif.object;
    //    for (TencentIMModel *model in array) {
    //        NSLog(@"ReceiveTencentMessage:%@",model);
    //    }
}
- (void)ClearRedPoint:(NSNotification*)notif{
    [self changeTheMesIcon:YES];
}

- (void)pushMessageClickJump:(NSNotification*)notif{
    XG_NoticeModel *model = (XG_NoticeModel*)(notif.object);
    [self jumpWithModel:model];
}

-(void)jumpWithModel:(XG_NoticeModel*)model{
    
    if (model.msgType == 1) {
        if (model.showType == 2 && model.jumpType==2 && model.indoorType==1 && model.activityId) {
            //缺书登记跳绘本
            IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
            vc.bookid = [NSString stringWithFormat:@"%d",model.activityId];
            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
            [XG_PushManager upDate:model Statuse:YES Callback:^(BOOL result) {
            }];
        }else{
            if (model.templateUrl.length) {
                BKCustomWebViewCtr *ctr = [[BKCustomWebViewCtr alloc]init];
                ctr.url = model.templateUrl;
                [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
                [XG_PushManager upDate:model Statuse:YES Callback:^(BOOL result) {
                }];
            }
        }
        
    }
}

- (void)pushHomePopupAction:(NSNotification*)notif{
    XG_NoticeModel *model = (XG_NoticeModel*)(notif.object);
    [self POPActiveViewWith:model];
}

- (void)pushMessageNotComing{
    [self changeTheMesIcon:NO];
    [CommonUsePackaging shareInstance].isMessageListNoticeRemind = YES;
}

- (void)POPActiveViewWith:(XG_NoticeModel*)model{
    
        BKHomePopUpTipCtr *ctr = [[BKHomePopUpTipCtr alloc]init];
        BOOL isfull = model.activityPushType == 1?YES:NO;
        [ctr showWithTitle:@"" andsubTitle:@"" andBtntitel:model.title andContent:model.content andImageName:model.msgPic andIsTap:YES andIsFullPic:isfull AndBtnAction:^{
            [ctr dissMissCtr];
            if (model.templateUrl.length) {
                BKCustomWebViewCtr *ctr = [[BKCustomWebViewCtr alloc]init];
                ctr.url = model.templateUrl;
                [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
            }
            [[NSUserDefaults standardUserDefaults] setObject:@(3) forKey:[NSString stringWithFormat:@"ActivePOPUP-%d",model.msgId]];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }];
        [ctr startShowTipWithController:self];
    
        NSInteger cout = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"ActivePOPUP-%d",model.msgId]] integerValue];
        //本地记录弹窗次数
        [[NSUserDefaults standardUserDefaults] setObject:@(cout+1) forKey:[NSString stringWithFormat:@"ActivePOPUP-%d",model.msgId]];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ActivePOPUP-List"] == nil) {
            NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:@(model.msgId), nil];
            //存入数组并同步
            [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"ActivePOPUP-List"];
        }else{
            NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ActivePOPUP-List"];
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:arr];
            [mutArr addObject:@(model.msgId)];
            //存入数组并同步
            [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"ActivePOPUP-List"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
}
//检查本地活动弹窗
- (void)checkTheActionPOP{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ActivePOPUP-List"] != nil) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"ActivePOPUP-List"];
        for (int i = 0; i<array.count; i++) {
            int msgId = [array[i] intValue];
            NSInteger cout = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"ActivePOPUP-%d",msgId]] integerValue];
            if (cout <2) {
                
                [XG_PushManager searchActivityModel:msgId Callback:^(NSMutableArray * _Nonnull array) {
                    if (array.count) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [self POPActiveViewWith:(XG_NoticeModel *)array.lastObject];
                        }];
                    }
                }];
                
            }
        }
    }
}
#pragma mark - UIResponder
-(void)eventName:(NSString *)eventname Params:(id)params
{
    
     [self changeTheMesIcon:YES];
    TallkNotificationController *vc= [[TallkNotificationController alloc]init];
    vc.observeArray = [NSArray arrayWithArray:self.messageArray];
    [self.navigationController pushViewController:vc animated:YES];
//    [MobClick event:EVENT_TALK_6];
    [[BaiduMobStat defaultStat] logEvent:@"c_mscr100" eventLabel:@"我的"];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
