//
//  TencentIMManager.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/9.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "TencentIMManager.h"
#import "AFNetworking.h"
#import <IMMessageExt/IMMessageExt.h>
#import "TalkMessageModel.h"
#import "EmojiObject.h"
#import "BKNewLoginController.h"
@interface TencentIMManager()<TIMMessageListener,TIMConnListener,TIMUserStatusListener,TIMRefreshListener>
@end
@implementation TencentIMManager
+(id)defautManager
{
    static dispatch_once_t onceToken;
    static TencentIMManager *tencentIMManager = nil;
    dispatch_once(&onceToken, ^{
        tencentIMManager = [[TencentIMManager alloc]init];
    });
    return tencentIMManager;
}
//从后台sevice获取登录token
-(void)launchTencentIM{
    [self configSDK];
}
//配置SDK
-(void)configSDK{
    
    TIMManager *manager = [TIMManager sharedInstance];
    TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
    config.sdkAppId = TENCENT_SDK_APPID;
    config.accountType = TENCENT_ACCOUNT_TYPE;
    config.disableLogPrint = YES;
    config.connListener = self;
    [manager initSdk:config];
    [manager addMessageListener:self];
    
    TIMUserConfig *userConfig = [[TIMUserConfig alloc] init];
    //    userConfig.disableStorage = YES;//禁用本地存储（加载消息扩展包有效）
    //    userConfig.disableAyutoReport = YES;//禁止自动上报（加载消息扩展包有效）
    //    userConfig.enableReadReceipt = YES;//开启C2C已读回执（加载消息扩展包有效）
    userConfig.disableRecnetContact = NO;//不开启最近联系人（加载消息扩展包有效）
    userConfig.disableRecentContactNotify = NO;//不通过onNewMessage:抛出最新联系人的最后一条消息（加载消息扩展包有效）
//    userConfig.enableFriendshipProxy = YES;//开启关系链数据本地缓存功能（加载好友扩展包有效）
    userConfig.enableGroupAssistant = YES;//开启群组数据本地缓存功能（加载群组扩展包有效）
//    TIMGroupInfoOption *giOption = [[TIMGroupInfoOption alloc] init];
//    giOption.groupFlags = 0xffffff;//需要获取的群组信息标志（TIMGetGroupBaseInfoFlag）,默认为0xffffff
//    giOption.groupCustom = nil;//需要获取群组资料的自定义信息（NSString*）列表
//    userConfig.groupInfoOpt = giOption;//设置默认拉取的群组资料
//    TIMGroupMemberInfoOption *gmiOption = [[TIMGroupMemberInfoOption alloc] init];
//    gmiOption.memberFlags = 0xffffff;//需要获取的群成员标志（TIMGetGroupMemInfoFlag）,默认为0xffffff
//    gmiOption.memberCustom = nil;//需要获取群成员资料的自定义信息（NSString*）列表
//    userConfig.groupMemberInfoOpt = gmiOption;//设置默认拉取的群成员资料
//    TIMFriendProfileOption *fpOption = [[TIMFriendProfileOption alloc] init];
//    fpOption.friendFlags = 0xffffff;//需要获取的好友信息标志（TIMProfileFlag）,默认为0xffffff
//    fpOption.friendCustom = nil;//需要获取的好友自定义信息（NSString*）列表
//    fpOption.userCustom = nil;//需要获取的用户自定义信息（NSString*）列表
//    userConfig.friendProfileOpt = fpOption;//设置默认拉取的好友资料
    userConfig.userStatusListener = self;//用户登录状态监听器
    userConfig.refreshListener = self;//会话刷新监听器（未读计数、已读同步）（加载消息扩展包有效）
    //    userConfig.receiptListener = self;//消息已读回执监听器（加载消息扩展包有效）
    //    userConfig.messageUpdateListener = self;//消息svr重写监听器（加载消息扩展包有效）
    //    userConfig.uploadProgressListener = self;//文件上传进度监听器
    //    userConfig.groupEventListener todo
//    userConfig.messgeRevokeListener = self.conversationMgr;
//    userConfig.friendshipListener = self;//关系链数据本地缓存监听器（加载好友扩展包、enableFriendshipProxy有效）
//    userConfig.groupListener = self;//群组据本地缓存监听器（加载群组扩展包、enableGroupAssistant有效）
    [manager setUserConfig:userConfig];
    NSLog(@"腾讯Im启动成功");
}


#pragma mark - imCallBack
/**
 *  网络事件通知
 */
//网络连接成功
- (void)onConnSucc
{
    NSLog(@"tencent网络连接成功");
}
//网络连接失败
- (void)onConnFailed:(int)code err:(NSString*)err
{
    NSLog(@"tencent网络连接失败:%@",err);
}
//网络连接断开（断线只是通知用户，不需要重新登录，重连以后会自动上线）
- (void)onDisconnect:(int)code err:(NSString*)err
{
    NSLog(@"tencent网络连接断开:%@",err);
}
//连接中
- (void)onConnecting
{
     NSLog(@"tencent连接中");
}


/**
 *  用户在线状态通知
 */
//踢下线通知
- (void)onForceOffline{
    
   //1 用户在线情况下的互踢
   //2 用户离线状态互踢
   //3 用户票据过期通知
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
//断线重连失败
- (void)onReConnFailed:(int)code err:(NSString*)err{
    
    NSLog(@"断线重连失败:%@",err);
}
//用户登录的 userSig 过期（用户需要重新获取 userSig 后登录）
- (void)onUserSigExpired{
    
    NSLog(@"用户登录的 userSig 过期");
}



/**
 *  刷新部分会话（包括多终端已读上报同步）
 *
 *  @param conversations 会话（TIMConversation*）列表
 */
- (void)onRefreshConversations:(NSArray*)conversations
{
    NSLog(@"tencent刷新部分会话:%@",conversations);
}
/*
 *  刷新会话
 */
- (void)onRefresh{
}
/** 拉取离线消息(为了不漏掉消息通知，需要在登录之前注册新消息通知)
 *  新消息回调通知
 *  登录后只能获取最近一条消息 可通过 getMessage获取漫游消息
 *  @param msgs 新消息列表，TIMMessage 类型数组
 */
- (void)onNewMessage:(NSArray*)msgs{

    for (TIMMessage *message in msgs) {
        TalkMessageModel *model =  [self tobeTalkMessageModel:message];
        [[NSNotificationCenter defaultCenter] postNotificationName:TENCENTIMMESSAGE object:model];
       
        
    }

}


#pragma mark - public
//登录
-(void)loginIn{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@%@",NewLoginSERVER_URL,@"/external/im/sig"];
    NSLog(@"path:%@",path);
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:nil error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *dic = (NSDictionary*)responseObject;
        if ([dic[@"code"] intValue] == 1) {
            self.sdkAppId = [dic[@"data"][@"sdkappid"] intValue];
            self.accountType = [NSString stringWithFormat:@"%@",dic[@"data"][@"accountType"]];
            self.userSign = dic[@"data"][@"userSign"];
            TIMLoginParam *param = [[TIMLoginParam alloc]init];
            param.appidAt3rd = [NSString stringWithFormat:@"%d",self.sdkAppId];
            param.userSig = self.userSign;
            param.identifier = [NSString stringWithFormat:@"%@",APP_DELEGATE.mLoginResult.userId];
            NSLog(@"self.manager==>xd%d",[TIMManager sharedInstance].getGlobalConfig.sdkAppId);
            [[TIMManager sharedInstance] login:param succ:^{
                NSLog(@"tencent登录登录成功");
                NSLog(@"mLoginResult.SN:%@",APP_DELEGATE.mLoginResult.SN);
                NSLog(@"mLoginResult.userId:%@",APP_DELEGATE.mLoginResult.userId);
                
            } fail:^(int code, NSString *msg) {
                
                NSLog(@"tencent登录失败%@ %d", msg,code);
                
            }];
            
        }else
        {
            //            [MBProgressHUD showError:dic[@"msg"]];
        }
        
    }];
    [task resume];

    
}

//登出
-(void)tencentLoginOut{
    
    TIMManager *manager = [TIMManager sharedInstance];
    [manager logout:^{
       
        NSLog(@"tencent 登出成功");
        
    } fail:^(int code, NSString *msg) {
        
        NSLog(@"tencent登出失败:%@",msg);
    }];
}
//发送文本消息
-(void)sendTextMessage:(NSString*)voiceURL Imtime:(NSString*)imtime succ:(TIMSucc)succ fail:(TIMFail)fail{
    TencentIMModel *model = [self getMessageModel:voiceURL Imtime:imtime];
    NSString *json = [model yy_modelToJSONString];
    NSLog(@"发送消息:messagejson:%@",json);
    TIMTextElem * text_elem = [[TIMTextElem alloc] init];
    [text_elem setText:json];
    TIMMessage * msg = [[TIMMessage alloc] init];
    [msg addElem:text_elem];
    TIMConversation * conversation = [self getConversation];
    [conversation sendMessage:msg succ:^(){
        NSLog(@"tencent SendMsg Succ");
        if (succ) {
            succ();
        }
    }fail:^(int code, NSString * err) {
        
        NSLog(@"SendMsg Failed:%d->%@", code, err);
        if (fail) {
            fail(code, err);
        }
    }];
}
//获取说说界面所有消息
-(void)getAllmessagesCallback:(void (^)(NSArray *array))block{
    
    [self getMessageCallback:nil];
    [self getLocalConversationMessagesCallback:^(NSArray *array) {
//        NSLog(@"allmessages===>%@",array);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *data = [NSMutableArray array];
            for (TIMMessage *message in array) {
                TalkMessageModel *model = [self tobeTalkMessageModel:message];
                if (model.nickName.length==0) {
                    
                    model.nickName = @"小布壳";
                }
                if (model) {
                    [data addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                block(data);
            });
            
        });
        
    }];
    
}



#pragma mark - private
//获取会话
-(TIMConversation*)getConversation{
    
    TIMConversation *conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:APP_DELEGATE.mLoginResult.SN];
    return conversation;
}

//构建消息体
-(TencentIMModel*)getMessageModel:(NSString*)voiceURL Imtime:(NSString*)imtime{
    TencentIMModel *model = [[TencentIMModel alloc]init];
    model.Identity = APP_DELEGATE.mLoginResult.appellativeName.length?APP_DELEGATE.mLoginResult.appellativeName:@"其它";
    model.sendImg = APP_DELEGATE.mLoginResult.wxImageUrl.length>0?APP_DELEGATE.mLoginResult.wxImageUrl:APP_DELEGATE.mLoginResult.imageUlr;
    model.audiourl = voiceURL;
    model.imtime = imtime;
    return model;
}

/*
 获取会话本地消息
**/
 
-(void)getLocalConversationMessagesCallback:(void (^)(NSArray *array))block{
    TIMConversation *conversation = [self getConversation];
    [conversation getLocalMessage:100 last:nil succ:^(NSArray *msgs) {
        
        block(msgs);
        
    } fail:^(int code, NSString *msg) {
        
        NSLog(@"会话本地消息:%d -- %@",code,msg);
    }];

}

/*
 获取会话离线消息
 **/
-(void)getMessageCallback:(void (^)(NSArray *array))block{
    TIMConversation *conversation = [self getConversation];
    [conversation getMessage:10 last:nil succ:^(NSArray *msgs) {
        if (block) {
             block(msgs);
        }
    } fail:^(int code, NSString *msg) {
        NSLog(@"会话离线消息:%d -- %@",code,msg);
    }];
    
}

/**
 *  获取会话消息
 *
 *  locators 消息定位符（TIMMessageLocator）数组
 *  succ  成功时回调
 *  fail  失败时回调
 *
 *  return 0 本次操作成功
 */
-(void)findMessagesCallback:(void (^)(NSArray *array))block{
    TIMConversation *conversation = [self getConversation];
    TIMMessageLocator *locator =[[TIMMessageLocator  alloc]init];
    locator.sessId = APP_DELEGATE.mLoginResult.SN;
    locator.sessType = TIM_GROUP ;
    [conversation findMessages:@[locator] succ:^(NSArray *msgs) {
        block(msgs);
    } fail:^(int code, NSString *msg) {
        NSLog(@"会话消息:%d -- %@",code,msg);
    }];
    
}
//处理消息(将消息转化为为TalkMessageModel)
-(TalkMessageModel*)tobeTalkMessageModel:(TIMMessage*)message{
    int cnt = [message elemCount];
    for (int i = 0; i < cnt; i++) {
        TIMElem * elem = [message getElem:i];
        if ([elem isKindOfClass:[TIMTextElem class]]) {
            TIMTextElem * text_elem = (TIMTextElem * )elem;
            TencentIMModel * tmodel = [TencentIMModel yy_modelWithJSON:text_elem.text];
            if (tmodel.audiourl.length) {
                NSDate *date = [message timestamp];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString *dateString = [formatter stringFromDate:date];
                TalkMessageModel *model = [[TalkMessageModel alloc]init];
                model.messageSenderType = !message.isSelf?MessageSenderTypeOther:MessageSenderTypeSelf;
                model.messageReadStatus = [self isReadWithMessageId:message.msgId]?MessageReadStatusRead:MessageReadStatusUnRead;
                model.showNickName = YES;
                model.nickName = tmodel.Identity;
                model.mId = message.msgId.intValue;
                model.showMessageTime = YES;
                model.messageTime = dateString;
                model.voiceUrl = tmodel.audiourl;
                model.duringTime = [tmodel.imtime integerValue]/1000;
                model.logoUrl =tmodel.sendImg;
                model.messageType = MessageTypeVoice;
                for (EmojiObject *object in [CommonUsePackaging shareInstance].emojiArray) {
                    if ([tmodel.audiourl isEqualToString:object.voiceUrl]) {
                        //表情 语音
                        model.messageType = MessageTypeImage;
                        model.imageSmall = [UIImage imageNamed:object.imageUrl];
                        break;
                    }
                }
                
                return model;
            }
            
        }
    }
    
    return nil;
    
}

-(BOOL)isReadWithMessageId:(NSString*)messageId{
    
    NSArray *array  = [[NSUserDefaults standardUserDefaults] objectForKey:@"TencentReadStatus"];
    for (NSString *tmessageid in array) {
        
        if ([messageId isEqualToString:tmessageid]) {
            return YES;
        }
    }
    
    return NO;
}
-(void)setMessageRead:(NSString*)messageId{
    
    NSArray *array  = [[NSUserDefaults standardUserDefaults] objectForKey:@"TencentReadStatus"];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:array];
    [temp addObject: [NSString stringWithFormat:@"%@",messageId]];
    NSArray *new_array = (NSArray*)temp;
    [[NSUserDefaults standardUserDefaults] setObject:new_array forKey:@"TencentReadStatus"];
    
    
}

@end
