//
//  AppDelegate.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2017/12/26.
//  Copyright © 2017年 深圳偶家科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "UserLoginViewController.h"
#import "HomeViewController.h"
#import "LoginResult.h"
#import "BookCategoryService.h"
#import <WXApi.h>
#import "WeChatManager.h"
#import "FetchUserSNService.h"
#import "LoginService.h"
#import "RCIMTokenService.h"
#import "AppKeySecretService.h"
#import "NSString+DES.h"
#import "MiniBuKe-Swift.h"
#import "MusicPlayTool.h"
#import "BKNewLoginController.h"
#import "BKNewLoginRequestManage.h"
#import <ShareSDK/ShareSDK.h>
//#import <React/RCTBundleURLProvider.h>
//#import <React/RCTRootView.h>
#import <Bugly/Bugly.h>
#import "XG_PushManager.h"
#import "LoginMaskingView.h"
#import "TencentIMManager.h"
#import "BaiduMobStat.h"
#import "XYDMSetting.h"
#import <IOTCamera/IOTCamera.h>
#import "BKCameraManager.h"
#import "BKBabyCareCallRingView.h"
#import "BKBabyCareMainCtr.h"
#import "BKVideoPlayController.h"
#import "ARLockView.h"
#import "JDOSSUploadfileHandle.h"
@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic, strong) BKUser *user ;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation AppDelegate
+(NSString *) getServerHost
{
    return SERVER_URL;
}

-(BOOL) isShowPromptEnterSexInfoWindow
{
    NSLog(@"APP_DELEGATE.mLoginResult.userId==>>%@", APP_DELEGATE.mLoginResult.userId);
    return [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@",APP_DELEGATE.mLoginResult.userId]];
}

-(void) setPromptEnterSexInfoWindowFlag:(BOOL) flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:[NSString stringWithFormat:@"%@",APP_DELEGATE.mLoginResult.userId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void) removeLoginResult
{
    self.mLoginResult = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginResult"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.ARviewCtr != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.ARviewCtr name:@"applicationWillEnterForeground" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self.ARviewCtr name:@"applicationWillResignActive" object:nil];
        self.ARviewCtr = nil;
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.isFirst = YES;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[UIButton appearance] setExclusiveTouch:YES];
    ProFile *proFile = [[ProFile alloc] init];
    [proFile show];
    
    //向微信注册(微信登录)
    [WXApi registerApp:WXLOGIN_APPID];
    //检查用户手机有无安装微信
    if ([WXApi isWXAppInstalled]) {
        self.isWXInstalled = YES;
    }else{
        self.isWXInstalled = NO;
    }
    //Mob分享
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //微信
        [platformsRegister setupWeChatWithAppId:WXLOGIN_APPID appSecret:WXLOGIN_APPSECRET];
    }];
    //bugly
    [Bugly startWithAppId:buglyId];
    //信鸽启动
    [[XG_PushManager shareInstance] launchXG_PushSeverce:launchOptions];
    //启动腾讯IM
//    [[TencentIMManager defautManager] launchTencentIM];
    //喜马拉雅
    [[XYDMSetting singleton] configXYDM];
    //初始化BabyCare-IOTC
    [Camera initIOTC];
  
    
    
    [self initData];
    [self initFetchUserSNService];
    
//    //获取融云key 连接融云服务器
    [self onAppKeySecretService];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    
    //刷新token 登录
    [self requestRefresh];
    [NSThread sleepForTimeInterval:1.88];//设置启动页时间
    
    //百度统计
    //设置渠道ID
    [BaiduMobStat defaultStat].enableDebugOn = NO;
    [[BaiduMobStat defaultStat] setChannelId:UMChannelName];
    //是否启用Crash日志收集
    [[BaiduMobStat defaultStat] setEnableExceptionLog:NO];
    //绑定用户自定义ID
    [[BaiduMobStat defaultStat] setUserId:self.mLoginResult.userName];
    [[BaiduMobStat defaultStat] getTestDeviceId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CallRingNoticAction:) name:@"BabyCareRingCall" object:nil];
    //屏蔽Documents目录自动备份到iCloud
    [self addNotBackUpiCloud];
    [JDOSSUploadfileHandle JD_OSS_Initialize];
    return YES;
}

-(void)onAppKeySecretService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"AppKeySecretService ==> OnSuccess");
        AppKeySecretService *service = (AppKeySecretService *) httpInterface;
        if (service.mXbkKeySecret != nil) {
            APP_DELEGATE.mXbkKeySecret = service.mXbkKeySecret;
            
            [self initRCSDK:APP_DELEGATE.mXbkKeySecret.appKey];
            NSLog(@"service.mXbkKeySecret.appkey ===>%@",service.mXbkKeySecret.appKey);
        }
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"AppKeySecretService ==> OnError");
        [self initRCSDK:RCIM_KEY];
    };
    NSString *userIdStr = [NSString stringWithFormat:@"%@",APP_DELEGATE.mLoginResult.userId];
    NSString *userId = [NSString des:userIdStr key: @"rnApzdA8PouJIAZKjX5JCEy1kQPqhx"];
    AppKeySecretService *service = [[AppKeySecretService alloc] init:OnSuccess setOnError:OnError setType:@"0" setUserId:userId];
    [service start];
}

-(void)initRCSDK:(NSString *) key
{
    //初始化RongIMLib
    [[RCIMClient sharedRCIMClient] initWithAppKey:key];
    //后台请求获取融云token
//    [self onRCIMTokenService];
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

-(void)initFetchUserSNService
{
    [XBKNetWorkManager requestUserFetchSNAndAndFinish:^(BKUserSNFetchModel * _Nonnull model, NSError * _Nonnull error) {
        if (error == nil && 1 == model.code) {
            if (APP_DELEGATE.mLoginResult != nil) {
                
                APP_DELEGATE.mLoginResult.SN = model.data.sn;
                [APP_DELEGATE saveLoginSuccessWithModel];
                

                APP_DELEGATE.snData = model.data;
                [APP_DELEGATE saveSNInfoWithModel];
                
            }
        }
    }];
}

-(void) initData
{
    NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginResult"];
    if (dic != nil) {
        self.mLoginResult = [[LoginResult alloc] init];
        self.mLoginResult.imageUlr = [dic objectForKey:@"imageUlr" ];
        self.mLoginResult.nickName = [dic objectForKey:@"nickName" ];
        self.mLoginResult.SN = [dic objectForKey:@"sn" ];
        self.mLoginResult.userName = [dic objectForKey:@"userName" ];
        self.mLoginResult.userId = [dic objectForKey:@"userId" ];
        self.mLoginResult.token = [dic objectForKey:@"token" ];
        self.mLoginResult.appellativeName = [dic objectForKey:@"appellativeName"];
        self.mLoginResult.hasBabyInfo = [dic objectForKey:@"hasBabyInfo"];
        self.mLoginResult.tokenDTO.refreshToken = [dic objectForKey:@"refreshToken"];
        self.mLoginResult.tokenDTO.accessToken = [dic objectForKey:@"token"];
        self.mLoginResult.wxNickName = [dic objectForKey:@"wxNickName"];
        self.mLoginResult.bindWx = [[dic objectForKey:@"bindWx"] integerValue];
        self.mLoginResult.wxImageUrl = [dic objectForKey:@"wxImageUrl"];
    }
    
    NSMutableDictionary *dic1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"XBKSNINFO"];
    if (dic1 != nil) {
        self.snData = [[SNDataModel alloc]init];
        self.snData.sn = [dic1 objectForKey:@"sn"];
        self.snData.type = [dic1 objectForKey:@"type"];
        self.snData.wifiImg = [dic1 objectForKey:@"wifiImg"];
        self.snData.unWifiImg = [dic1 objectForKey:@"unWifiImg"];
        self.snData.version = [dic1 objectForKey:@"version"];
        self.snData.uid = [dic1 objectForKey:@"uid"];
    }

    if(4 == [APP_DELEGATE.snData.type integerValue]){
        [[BKCameraManager shareInstance] ConnectDevice];
    }

}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([WXApi handleOpenURL:url delegate:(id)[WeChatManager sharedManager]]) {
        return YES;
    }
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([WXApi handleOpenURL:url delegate:(id)[WeChatManager sharedManager]]) {
        return YES;
    }
    return YES;
}

//ios9+
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([WXApi handleOpenURL:url delegate:(id)[WeChatManager sharedManager]]) {
        return YES;
    }
    
    return YES;
}
//注册用户通知设置
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
 
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //userInfo 为远程推送的内容

    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    

    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
   
}




- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"app从前台到后台--[ARLockView stopAR]");
     [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillResignActive" object:nil];
    [ARLockView stopAR];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"appc到后台");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
   
    NSLog(@"appc到前台");
//    [UIApplication sharedApplication].statusBarHidden = NO ;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (APP_DELEGATE.mLoginResult.token.length) {
        [XG_PushManager pullNotifacationData];
    }
    if(4 == [APP_DELEGATE.snData.type integerValue]){
        [[BKCameraManager shareInstance] ConnectDevice];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//    BOOL is = self.mHomeViewController.currentTabIndex == TabIndex_EnglishView;
    [[ARAudioManager singleton] stopPlay];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillEnterForeground" object:nil];
  
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - UNUserNotificationCenterDelegate
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0)){

    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
API_AVAILABLE(ios(10.0)){

    
}

#pragma mark - Core Data stack
@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"MiniBuKe"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)requestRefresh{
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    LoginMaskingView *view = [[LoginMaskingView alloc]init];
    view.frame = [UIScreen mainScreen].bounds;
    UIViewController *ctr = [[UIViewController alloc]init];
    [ctr.view addSubview:view];
    self.navigationController = [[BKNavgationController alloc] initWithRootViewController:ctr];
    self.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    if (self.mLoginResult.tokenDTO.refreshToken.length) {
        //刷新token
        [self refreshTokenRequest];
    }else{
        BKNewLoginController *loginCtr = [[BKNewLoginController alloc]init];
        self.navigationController = [[BKNavgationController alloc] initWithRootViewController:loginCtr];
        self.window.rootViewController = self.navigationController;
    }

}

/** 配置rootViewController */
-(void)configRootViewController{
    if (self.mLoginResult.token.length && self.mLoginResult.tokenDTO.refreshToken.length) {//有token直接跳首页
        HomeViewController *mHomeViewController = [[HomeViewController alloc] init];
        self.navigationController = [[BKNavgationController alloc] initWithRootViewController:mHomeViewController];
        self.window.rootViewController = self.navigationController;
        
    }else{//跳登录页
        BKNewLoginController *loginCtr = [[BKNewLoginController alloc]init];
        self.navigationController = [[BKNavgationController alloc] initWithRootViewController:loginCtr];
        self.window.rootViewController = self.navigationController;
    }
    [self.window makeKeyAndVisible];
}
#pragma mark - 自动登录刷新token
/**刷新token接口*/
- (void)refreshTokenRequest{
    if (self.mLoginResult.tokenDTO.refreshToken.length) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [BKNewLoginRequestManage requestRefreshTokenWithtoken:self.mLoginResult.tokenDTO.refreshToken AndFinish:^(id  _Nonnull responsed, NSError * _Nonnull error) {
                if (error == nil) {
                    if ([[responsed objectForKey:@"code"] integerValue] == 1) {
                        //刷新成功
                        NSLog(@"刷新token成功");
                        [self saveLoginSuccessWithDictionary:[responsed objectForKey:@"data"]];
                        
                        [[BaiduMobStat defaultStat] logEvent:@"e_login100" eventLabel:@"token自动登录"];
                        //跳转首页
                        HomeViewController *mHomeViewController = [[HomeViewController alloc] init];
                        self.navigationController = [[BKNavgationController alloc] initWithRootViewController:mHomeViewController];
                        self.window.rootViewController = self.navigationController;
                        self.isFirst = NO;
                    }else if ([[responsed objectForKey:@"code"] integerValue] == 10010){
                        //refreshToken失效时候,弹出登录界面
                        [self removeLoginResult];
                        BKNewLoginController *loginCtr = [[BKNewLoginController alloc]init];
                        self.navigationController = [[BKNavgationController alloc] initWithRootViewController:loginCtr];
                        self.window.rootViewController = self.navigationController;

                    }else{
                        BKNewLoginController *loginCtr = [[BKNewLoginController alloc]init];
                        self.navigationController = [[BKNavgationController alloc] initWithRootViewController:loginCtr];
                        self.window.rootViewController = self.navigationController;
                    }
                    self.isFirst = NO;

                }else{
                    BKNewLoginController *loginCtr = [[BKNewLoginController alloc]init];
                    self.navigationController = [[BKNavgationController alloc] initWithRootViewController:loginCtr];
                    self.window.rootViewController = self.navigationController;
                    self.isFirst = NO;

                }
            }];
        });
    }
}

-(void)saveLoginSuccessWithDictionary:(NSDictionary *)dic{
    LoginResult *mLoginResult = [LoginResult withLoginResultJson:dic];
    if (dic != nil && mLoginResult != nil) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
        [mutableDictionary setValue:mLoginResult.imageUlr forKey:@"imageUlr" ];
        [mutableDictionary setValue:mLoginResult.nickName forKey:@"nickName" ];
        [mutableDictionary setValue:mLoginResult.SN forKey:@"sn" ];
        [mutableDictionary setValue:mLoginResult.userName forKey:@"userName" ];
        [mutableDictionary setValue:mLoginResult.userId forKey:@"userId" ];
        [mutableDictionary setValue:mLoginResult.tokenDTO.accessToken forKey:@"token" ];
        [mutableDictionary setValue:mLoginResult.appellativeName forKey:@"appellativeName" ];
        [mutableDictionary setValue:mLoginResult.hasBabyInfo forKey:@"hasBabyInfo"];
        [mutableDictionary setValue:mLoginResult.tokenDTO.refreshToken forKey:@"refreshToken" ];
        [mutableDictionary setValue:mLoginResult.wxNickName forKey:@"wxNickName" ];
        [mutableDictionary setValue:@(mLoginResult.bindWx) forKey:@"bindWx"];
        [mutableDictionary setValue:mLoginResult.wxImageUrl forKey:@"wxImageUrl" ];

        [[NSUserDefaults standardUserDefaults] setObject:mutableDictionary forKey:@"LoginResult"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self setMLoginResult:mLoginResult];
        
        //推送绑定账号
        [[XG_PushManager shareInstance] bindAccount:APP_DELEGATE.mLoginResult.userName];
        //推送绑定标签
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        [[XG_PushManager shareInstance] bindTag:app_Version];

    }
}

-(void)saveLoginSuccessWithModel{
    if (self.mLoginResult != nil) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
        [mutableDictionary setValue:self.mLoginResult.imageUlr forKey:@"imageUlr" ];
        [mutableDictionary setValue:self.mLoginResult.nickName forKey:@"nickName" ];
        [mutableDictionary setValue:self.mLoginResult.SN forKey:@"sn" ];
        [mutableDictionary setValue:self.mLoginResult.userName forKey:@"userName" ];
        [mutableDictionary setValue:self.mLoginResult.userId forKey:@"userId" ];
        [mutableDictionary setValue:self.mLoginResult.tokenDTO.accessToken forKey:@"token" ];
        [mutableDictionary setValue:self.mLoginResult.appellativeName forKey:@"appellativeName" ];
        [mutableDictionary setValue:self.mLoginResult.hasBabyInfo forKey:@"hasBabyInfo"];
        [mutableDictionary setValue:self.mLoginResult.tokenDTO.refreshToken forKey:@"refreshToken" ];
        [mutableDictionary setValue:self.mLoginResult.wxNickName forKey:@"wxNickName" ];
        [mutableDictionary setValue:@(self.mLoginResult.bindWx) forKey:@"bindWx"];
        [mutableDictionary setValue:self.mLoginResult.wxImageUrl forKey:@"wxImageUrl" ];
        
        [[NSUserDefaults standardUserDefaults] setObject:mutableDictionary forKey:@"LoginResult"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)saveSNInfoWithModel{
    if (self.snData != nil) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
        [mutableDictionary setValue:self.snData.sn forKey:@"sn"];
        [mutableDictionary setValue:self.snData.type forKey:@"type"];
        [mutableDictionary setValue:self.snData.wifiImg forKey:@"wifiImg"];
        [mutableDictionary setValue:self.snData.unWifiImg forKey:@"unWifiImg"];
        [mutableDictionary setValue:self.snData.version forKey:@"version"];
        [mutableDictionary setValue:self.snData.uid forKey:@"uid"];

        [[NSUserDefaults standardUserDefaults] setObject:mutableDictionary forKey:@"XBKSNINFO"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (4 == [self.snData.type integerValue]) {//type 4 ,babycare
            if ([BKCameraManager shareInstance].deviceState != DeviceContentStateType_onLine)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[BKCameraManager shareInstance] ConnectDevice];
                });
            }
            
        }
    }
}

-(void)removeSNInfoSave
{

    self.snData = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"XBKSNINFO"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - babycare来电推送相关
- (void)CallRingNoticAction:(NSNotification*)notic{
    if ([self.snData.type integerValue] != 4) {
        return;
    }
    XG_NoticeModel *model = (XG_NoticeModel*)notic.object;
    //判断来电时间是否在65秒内
    if (65 >= [self deltaTimeWithNowAndtimestamp:model.pushStartTime]) {
        //判断本地是否已经记录了通话弹窗
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *array = [userDefaults objectForKey:@"CallRingIsShowData"];
        if (array == nil) {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:@(model.activityId)];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"CallRingIsShowData"];
        }else{
            if ([array containsObject:@(model.activityId)] ) {
                return;
            }else{
                NSMutableArray *mutableCopyArray = [array mutableCopy]; //重要步骤操作mutableCopyArray
                [mutableCopyArray addObject:@(model.activityId)];
                [userDefaults setObject: mutableCopyArray forKey:@"CallRingIsShowData"];
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //如果当前是全屏视频,先取消全屏在弹来电界面
        if ([BKVideoPlayController shareInstance].playView.isFullView) {
            [[BKVideoPlayController shareInstance].playView cancelFullScreen];
        }
        
        NSLog(@"电话可接听");
        //如果设备离线,就重新连接下
        if ([BKCameraManager shareInstance].deviceState != DeviceContentStateType_onLine) {
            [[BKCameraManager shareInstance] ConnectDevice];
        }
        UIStatusBarStyle state = [UIApplication sharedApplication].statusBarStyle;
        //来电提示弹窗
        BKBabyCareCallRingView *CallView = [[BKBabyCareCallRingView alloc]init];
        [CallView setBtnClick:^(BOOL isAccecpt) {
            [UIApplication sharedApplication].statusBarStyle = state;
            if (isAccecpt) {//接听
                NSLog(@"已接听");
                BKBabyCareMainCtr *babyCareCtr = [[BKBabyCareMainCtr alloc]init];
                babyCareCtr.isNeedPopMore = NO;
                babyCareCtr.noticModel = model;
                [APP_DELEGATE.navigationController pushViewController:babyCareCtr animated:YES];
                //上报接听状态
                [XBKNetWorkManager requestUpdateCallRecordsWithID:model.activityId andState:1 AndAndFinish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                }];
                
            }else{//挂断
                NSLog(@"已挂断");
                [[BKCameraManager shareInstance] refuseTheDeviceTalk];
                //上报挂断状态
                [XBKNetWorkManager requestUpdateCallRecordsWithID:model.activityId andState:2 AndAndFinish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                }];
                
            }
        }];
        if (self.isFirst) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                [[UIApplication sharedApplication].keyWindow addSubview:CallView];
            });
        }else{
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                [[UIApplication sharedApplication].keyWindow addSubview:CallView];
        }

    }else{
        NSLog(@"电话超时");
    }
}

- (NSInteger)deltaTimeWithNowAndtimestamp:(NSString*)timeStr{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromTimesp =[dateFormat dateFromString:timeStr];
    //    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateComponents *componets =[confromTimesp deltaWithNow];
    return componets.second;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BabyCareRingCall" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotBackUpiCloud{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* docPath = [documentPaths objectAtIndex:0];
    [self addSkipBackupAttributeToItemAtURL:docPath];
}

/**
 *屏蔽Documents 目录/ios文件不备份到icloud
 */
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)filePathString{
    NSURL* URL = [NSURL fileURLWithPath:filePathString];
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                  forKey:NSURLIsExcludedFromBackupKey error:&error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end
