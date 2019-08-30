//
//  CommonHeader.h
//  MiniBuKe
// 公共方法的头文件宏定义
//  Created by zhangchunzhe on 2018/2/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#ifndef CommonHeader_h
#define CommonHeader_h


#define ISDEBUG YES

#define IS_FULL_VERSION NO

#define IS_Monitor_Model NO

#define JsAction @"JsAction"
//#define EVENT_LOGIN_1 @"1" //1,登录,0
//#define EVENT_OUT_LOGIN_2 @"2" //2,退出登录,0
//#define EVENT_TAB_BOOK_3 @"3" //3,绘本tab,0
//#define EVENT_TAB_LISTENT_4 @"4"//4,听听tab,0
//#define EVENT_TAB_MY_5 @"5"//5,我的tab,0
//#define EVENT_TALK_6 @"6"//6,说说入口,0
//#define EVENT_LEFT_7 @"7"//7,侧边栏入口,0
//#define EVENT_INFO_8 @"8"//8,个人信息,0
//#define EVENT_BABY_INFO_9 @"9"//9,宝贝信息,0
//#define EVENT_DEVICE_MANAGE_10 @"10"//10,设备管理,0
//#define EVENT_FEEDBACK_11 @"11"//11,意见反馈,0
//#define EVENT_ABUOT_12 @"12"//12,关于,0
//#define EVENT_BABY_RACK_13 @"13"//13,宝宝书架,0
//#define EVENT_LISTENT_COLLECT_14 @"14"//14,听听收藏,0
//#define EVENT_K_BOOK_15 @"15"//15,K绘本,0
//#define EVENT_RECENTLY_PLAY_16 @"16"//16,最近播放,0

//#define EVENT_NEWRegister_17 @"17" //17,新用户注册, 1

//#define EVENT_Custom_100 @"100" //1288活动banner点击
//#define EVENT_Custom_101 @"101" //活动页曝光
//#define EVENT_Custom_102 @"102" //活动页分享按钮
//#define EVENT_Custom_103 @"103" //活动页立即购买按钮
//#define EVENT_Custom_104 @"104" //购买页确认宝宝信息
//#define EVENT_Custom_105 @"105" //支付购买点击
//#define EVENT_Custom_106 @"106" //收银台点击
//#define EVENT_Custom_107 @"107" //开启微信支付点击
//#define EVENT_Custom_108 @"108" //确认放弃支付点击
//#define EVENT_Custom_109 @"109" //购买成功曝光
//#define EVENT_Custom_110 @"110" //购买成功后分享点击
//#define EVENT_Custom_111 @"111" //分享微信朋友圈
//#define EVENT_Custom_112 @"112" //分享微信好友
//#define EVENT_Custom_113 @"113" //保存图片
//#define EVENT_Custom_114 @"114" //二维码扫描
//#define EVENT_Custom_115 @"115" //领取优惠券
//#define EVENT_Custom_116 @"116" //去了解一下

//#define EVENT_Custom_130 @"130" //点击精读详情


#define isiPad ([UIDevice currentDevice].userInterfaceIdiom == 1)
#define IS_PAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#define is_IPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#define is_IPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
#define is_IPhone6 ([UIScreen mainScreen].bounds.size.height == 667)
#define is_IPhone6P ([UIScreen mainScreen].bounds.size.height == 736)

#define k_WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_SCALE_X ([UIScreen mainScreen].bounds.size.width / 1080.0)
#define SCREEN_SCALE_X_New ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? ([[UIScreen mainScreen] scale] < 3.0f ? 667.0/1920.0 : 667.0/1920.0 * 1.0) : 667.0/1920.0)
#define SCREEN_SCALE_Y ([UIScreen mainScreen].bounds.size.height / 1920.0)
#define SCREEN_SCALE_Y_New ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? ([[UIScreen mainScreen] scale] < 3.0f ? 375.0/1080.0 : 375.0/1080.0 * 1.0) : 375.0/1080.0)
#define SCREEN_SCALE_MIN (SCREEN_SCALE_X < SCREEN_SCALE_Y ? SCREEN_SCALE_X : SCREEN_SCALE_Y)
#define SCREEN_SCALE_MAX ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && (SCREEN_SCALE_X > SCREEN_SCALE_Y) ? SCREEN_SCALE_X : SCREEN_SCALE_Y)

#define kMagicScale(X) (X * ([UIScreen mainScreen].bounds.size.height/667.0 > 0.8 ? [UIScreen mainScreen].bounds.size.height/667.0 : 0.8))

#define SIZE_X(x) [UIApplication sharedApplication].keyWindow.bounds.size.width/375.f*x
#define SIZE_Y(y) [UIApplication sharedApplication].keyWindow.bounds.size.height/667.f*y

#define kMessageRequestTimeInterval 60

#define kUXScaleAnima_Duration 0.3
#define kUXAnimaScaleTransform_92(aView) ([UIView animateWithDuration:kUXScaleAnima_Duration animations:^{aView.transform = CGAffineTransformMakeScale(0.92, 0.92);}]);
#define kUXAnimaIdentityTransform(aView) ([UIView animateWithDuration:kUXScaleAnima_Duration animations:^{aView.transform = CGAffineTransformIdentity;}]);
#define kUXAnimaScaleTransform_120(aView) ([UIView animateWithDuration:kUXScaleAnima_Duration animations:^{aView.transform = CGAffineTransformMakeScale(1.2, 1.2);}]);
//课本出版社
#define kPublicWAIYAN 1

#define KCollectImage_Transcale ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 0.7 : 1.0)

#define SUDO_MAX_NUM 16
#define DEGITAL_LINE 9








//=====================================================================



//notification
#define NotificationLock CFSTR("com.apple.springboard.lockcomplete")
#define NotificationChange CFSTR("com.apple.springboard.lockstate")
#define NotificationPwdUI CFSTR("com.apple.springboard.hasBlankedScreen")







#define kSettinStateFromKey(aKey) ([[NSUserDefaults  standardUserDefaults] boolForKey:aKey])

#define kNotificationLoadCancel @"cancelDownloadSource"
#define kPOST_DOWNLOAD_CANCEL_NOTIFICATION(obj) ([[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadCancel object:obj])
#define kNotice_SCORELIST_FRIENF_ADD @"add_friend_notice"

#define kQRCode_WeichatStyle_Resource @"qrcode_resource.bundle/qrcode_Scan_weixin_Line"

#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]
#define RGBA(A,B,C,D) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:D]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define kUserLogIn @"userLogin"

#define BkApp (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define USER_ID ((AppDelegate*)[UIApplication sharedApplication].delegate).userInfo.userId


#define kUserStudyPath ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"UStudy"])
#define kUserDomainPath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"UStudy"])
#define kUserPlistPath ([kUserDomainPath stringByAppendingPathComponent:@"user.plist"])

#define kCurrentUser ((NSString *)[NSMutableDictionary dictionaryWithContentsOfFile:kUserPlistPath][kUserLogIn])
//#define kCurrentUserPath [kUserStudyPath stringByAppendingPathComponent:kCurrentUser]
//#define kCurrentUserPath [kUserStudyPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",[appdelegate userInfo].userId]]
#define kCurrentUserPath [kUserStudyPath stringByAppendingPathComponent:([NSString stringWithFormat:@"%ld",[appdelegate userInfo].userId])]



#define LoadNib(nibName) \
[[NSBundle mainBundle]loadNibNamed:(nibName) owner:self options:nil][lastObject]



//用于适配尺寸
#define phResizeWidth(width) is_IPhone4 || is_IPhone5 ? 320.0 / 375.0 * width : is_IPhone6P ? width : 414.0 / 375.0 * width
#define phResizeHeight(height) is_IPhone4 ? 480.0 / 667.0 * height : is_IPhone5 ? 568.0 / 667.0 * height : is_IPhone6P ? height : 736.0 / 667.0 * height

//#define kSystemFontWithPx(x) [UIFont systemFontOfSize: (CGFloat)x * 72 / ([UIScreen mainScreen].bounds.size.width > 375 ? 154 : 163)]
//#define kPx_Magic_Pt 0.5 * 0.85 * ([UIScreen mainScreen].bounds.size.height/667.0 > 0.8 ? [UIScreen mainScreen].bounds.size.height/667.0 : 0.8)
#define kABS_HEIGHT(Y,Y1) ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? ([[UIScreen mainScreen] scale] < 3.0f ? Y/1920.0*667.0 : Y/1920.0*667.0 * 1.0) : Y1/1920.0*667.0)
#define kABS_Width(X,X1) ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? ([[UIScreen mainScreen] scale] < 3.0f ? X/1080.0*375.0 : X/1080.0*375.0 * 1.0) : X1/1080.0*375.0)

#define kPx_Magic_Pt_EN 0.5 * 0.85
#define kPx_Magic_Pt_CN 0.5 * 0.75
#define kSystemFontWithPx(x) [UIFont systemFontOfSize: (CGFloat)x * kPx_Magic_Pt_CN]  //standard for Photoshop
#define kSystemIpadFontWithPx(x) [UIFont systemFontOfSize: (CGFloat)x * 0.5 * 0.85]
#define kFontWithNameAndPx(name, x) [UIFont fontWithName:name size:(CGFloat)x * 72 / ([UIScreen mainScreen].bounds.size.width > 375 ? 154 : 163)]
#define kSystemBoldFontWithPx(x) ([UIFont boldSystemFontOfSize:(CGFloat)x * 72 / ([UIScreen mainScreen].bounds.size.width > 375 ? 154 : 163)])
#define kSystemFont(X) ([UIFont systemFontOfSize:X])
#define kSystemBoldFont(X) ([UIFont boldSystemFontOfSize:X * kPx_Magic_Pt_CN])
//#define kSystemFontWithPx1(x) ([UIFont systemFontOfSize:kPT_Font(x)])
#define kSystemFontWithPx1(x) kSystemFontWithPx(x)
#define kSystemFontWithName_Px(NAME,Px) ([UIFont fontWithName:NAME size:(CGFloat)Px * kPx_Magic_Pt_CN])
#define kSystemFontPHONE_PADWithName_Px(NAME,Px,Py) ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? [UIFont fontWithName:NAME size:(CGFloat)Px * kPx_Magic_Pt_CN] : [UIFont fontWithName:NAME size:(CGFloat)Px * 0.5 * 0.85])

#define kStringFromNumber(num) [NSString stringWithFormat:@"%ld",num]
#define kStringFromDouble(num) [NSString stringWithFormat:@"%.f",num]

#define kStringFromeIndexPath(path) [NSString stringWithFormat:@"%ld-%ld",path.section,path.row]

#define kCurrentBookName ([UXScoreResults shareInstance].bookName)
#define kCurrentModuleName ([UXScoreResults shareInstance].downloadModuleName)
#define kCurrentBookID kStringFromNumber([UXScoreResults shareInstance].bookID)

#define kDPX_IPHONE_PAD_Normal(X,X1,X2) ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? (X ? (X1 * SCREEN_SCALE_Y) : (X1 * SCREEN_SCALE_X)) : kPT_iPad(X2))
#define kDPX_IPHONE_PAD(X,X1,X2) ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? ((X) ? ((X1) * SCREEN_SCALE_MAX) : ((X1) * SCREEN_SCALE_X)) : kPT_iPad((X2)))
#define kDPX_IPHONE_PAD_Font(X1,X2) ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? kSystemFontWithPx(X1) : kSystemIpadFontWithPx(X2))

#define MY_FONT(size) [UIFont systemFontOfSize:size]
#define kIPadScaleRate * 1.0  //错题本适配

#define EXITBTN_TOP (25 * SCREEN_SCALE_Y)
#define EXITBTN_LEFT (30 * SCREEN_SCALE_X)
#define EXITBTN_WIDTH (90 * SCREEN_SCALE_Y)




//获取16进制的颜色值
#define COLOR_STRING(colorString) [UIColor colorWithHexStr:colorString]
#define A_COLOR_STRING(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]



//设备版本
#define iS_iOS8 [UIDevice currentDevice].systemVersion.doubleValue >= 8.0
#define iS_iOS8_BEFORE [UIDevice currentDevice].systemVersion.doubleValue < 8.0
#define iS_iOS9_BEFORE [UIDevice currentDevice].systemVersion.doubleValue < 9.0
#define iS_iOS9 [UIDevice currentDevice].systemVersion.doubleValue >= 9.0
#define iS_iOS8_Later iS_iOS8
#define iS_iOS9_Later iS_iOS9

#define iOS11_LATER      (([[[UIDevice currentDevice]systemVersion] floatValue] >= 11.0) ? YES : NO)
#define iOS9_LATER      (([[[UIDevice currentDevice]systemVersion] floatValue] >= 9.0) ? YES : NO)
#define iOS8_LATER      (([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0) ? YES : NO)
#define iOS7_LATER      (([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) ? YES : NO)
#define iOS6_LATER      (([[[UIDevice currentDevice]systemVersion] floatValue] >= 6.0) ? YES : NO)




// not UIUserInterfaceIdiomPad
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// detect iPhone6 Plus based on its native scale
#define IS_IPHONE_6PLUS (IS_IPHONE && [[UIScreen mainScreen] scale] == 3.0f)
// detect iPhone6 Plus based on its native scale
#define IS_IPHONE_6PLUS_BELOW (IS_IPHONE && [[UIScreen mainScreen] scale] < 3.0f)

//iPhoneX 及 iOS11 适配
#define iPhoneX [[UIScreen mainScreen] bounds].size.width >= 375.0f && [[UIScreen mainScreen] bounds].size.height >= 812.0f && IS_IPHONE

#define iPad [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad

#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}




#define kWS_Show_Label_Width kDPX_IPHONE_PAD(0,680, 850)



#define kAPP_ID_KEY @"APP-ID"
#define kAPP_USERID_KEY @"USER-ID"
#define kAPP_Secret_KEY @"APP-Secret"
#define kAPP_ID_VALUE @"123456"
#define kAPP_Secret_VALUE @"e5456b12567c80d79040490c6169f4f5"
#define kLogin_token_KEY @"Login-Token"




#define kWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define FHWeakSelf __weak typeof(self) weakSelf = self;

#define kUXShareLink @"http://share.aiuxue.com/uxue/invite"

//App ID
#define kWeiChatAPP_ID @"wx562047519b3055f4"
#define kWeiChatAPP_SECRET @"35c44339fe62aab3716bf856fb7400e8"
#define kTencentAPP_ID @"1104921766"
#define kSinaAPP_Key @"2268718384"
#define kWeiboRedirectURL @"https://api.weibo.com/oauth2/default.html"

#define WXLOGIN_APPID @"wx0f35e35b6a6c7188"
#define WXLOGIN_APPSECRET @"58b5738e0664f225331bbda09eea9c0f"


//String 格式化
#define I_STRING(num)  [NSString stringWithFormat:@"%d",num]
#define L_STRING(num)  [NSString stringWithFormat:@"%ld",num]

//Color
#define C_TitleColor [UIColor colorWithRed:255.0 / 255.0 green:80.0 / 255.0 blue:1.0 / 255.0 alpha:1.0]

//iphoneX 适配相关

#define IS_IPHONE_X (SCREEN_HEIGHT == 812.0f) ? YES : NO

#define Height_NavContentBar 44.0f

#define Height_StatusBar (IS_IPHONE_X==YES)?44.0f: 20.0f

#define Height_NavBar   (IS_IPHONE_X==YES)?88.0f: 64.0f

#define Height_TabBar   (IS_IPHONE_X==YES)?83.0f: 49.0f

///** 刷新控件的状态 */
//typedef NS_ENUM(NSInteger, MJRefreshState) {
//    /** 普通闲置状态 */
//    MJRefreshStateIdle = 1,
//    /** 松开就可以进行刷新的状态 */
//    MJRefreshStatePulling,
//    /** 正在刷新中的状态 */
//    MJRefreshStateRefreshing,
//    /** 即将刷新的状态 */
//    MJRefreshStateWillRefresh,
//    /** 所有数据加载完毕，没有更多的数据了 */
//    MJRefreshStateNoMoreData
//};
#define MJRefreshStateIdle_Str @"上拉加载"
#define MJRefreshStatePulling_Str @"松开加载"
#define MJRefreshStateRefreshing_Str @"正在加载..."
#define MJRefreshStateWillRefresh_Str @"加载完成"
#define MJRefreshStateNoMoreData_Str @"最后一页了"

//适配iPhoneX
#define kStatusBarH     [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavbarH   (44.f + kStatusBarH)
#define SCALE(a) (a)*SCREEN_WIDTH/375

//h5地址
//token编码
#define TokenEncode [APP_DELEGATE.mLoginResult.token stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]]
//   1. banner01  套餐详情页（长图）
#define ComboLongPic [NSString stringWithFormat:@"%@/template/html/yyh5/yyDetails/index.html",H5SERVER_URL]
//   2. banner02  返现套餐介绍
#define ComboReturnIntroduce [NSString stringWithFormat:@"%@/template/html/yyh5/banner2/",H5SERVER_URL]
//   3. 我的订单
#define MyOrders [NSString stringWithFormat:@"%@/template/html/yyh5/purchase/index.html?token=%@",H5SERVER_URL,TokenEncode]
//   4. 地址编辑
#define BKAdressEditor [NSString stringWithFormat:@"%@/template/html/yyh5/purchase/editor.html?token=%@",H5SERVER_URL,TokenEncode]
//   5. 购买需知
#define BuyNeedToKnow [NSString stringWithFormat:@"%@/template/html/yyh5/needToKnow/index.html",H5SERVER_URL]
//   6. 购买服务协议
#define BuySeveiceAgreenMent [NSString stringWithFormat:@"%@/template/html/yyh5/agreement/index.html",H5SERVER_URL]
#define BabyInfo_HasChanged_Notifaction @"BabyInfo_HasChanged_Notifaction"
//   7. 钱包地址
#define H5Wallet [NSString stringWithFormat:@"%@/template/html/yyh5/purse/index.html",H5SERVER_URL]
//   8. 钱包提现地址
#define H5WalletDraw [NSString stringWithFormat:@"%@/template/html/yyh5/purse/cash.html",H5SERVER_URL]
//   9. 提现进度地址
#define H5DrawProgress [NSString stringWithFormat:@"%@/template/html/yyh5/purse/progress.html",H5SERVER_URL]
//  10. 徽章
#define EmblemAddress [NSString stringWithFormat:@"%@/template/html/badge/badge.html?token=%@",H5SERVER_URL,TokenEncode]
//阅读报告
#define ReadReportAdress [NSString stringWithFormat:@"%@/template/html/readReport/readReport.html?token=%@&notShare=true",H5SERVER_URL,TokenEncode]
//   11.会员
#define MemberToBuy [NSString stringWithFormat:@"%@/template/html/vipPage/vipPage.html",H5SERVER_URL]

//更多课程列表
#define MoreCourseList [NSString stringWithFormat:@"%@/template/html/courseListPage/courseListPage.html",H5SERVER_URL]
//已购课程
#define BuyedCourseList [NSString stringWithFormat:@"%@/template/html/courseListPage/courseListPage.html?token=%@",H5SERVER_URL,TokenEncode]
//通知宏,首页弹窗通知
#define PushNoticHomePOP @"BK_PushNoticHomePOP"
//通知宏,首页显示红点通知
#define PushNoticComing @"BK_PushNoticComing"
//点击通知页面跳转
#define PushClickJump @"BK_PushClickJump"
//消息中心返回去掉红点
#define PushBackClearRedPoint @"PushBackClearRedPoint"

//小布壳机器人类型
typedef NS_ENUM(NSInteger, XBK_RobotType){
    XBK_RobotType_Q1 = 1,//Q1
    XBK_RobotType_super = 2,//Titan
    XBK_RobotType_Q1_A33 = 3,//Q1 A33
    XBK_RobotType_babycare = 4,//babycare
    XBK_RobotType_chill = 5,//京东chill
};

#endif /* CommonHeader_h */

