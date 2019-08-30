//
//  TencentIMManager.h
//  MiniBuKe
//
//  Created by chenheng on 2019/1/9.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
#import "NSObject+YYModel.h"
#import "TencentIMModel.h"
#import "CommonUsePackaging.h"
#define TENCENTIMMESSAGE @"TENCENTIMMESSAGE_NOTIFACTION"
//NS_ASSUME_NONNULL_BEGIN

@interface TencentIMManager : NSObject
@property(nonatomic,copy)NSString *userSign;
@property(nonatomic,assign)int sdkAppId;
@property(nonatomic,copy)NSString *accountType;
+(id)defautManager;
-(void)launchTencentIM;
-(void)loginIn;
-(void)tencentLoginOut;
-(void)sendTextMessage:(NSString*)voiceURL Imtime:(NSString*)imtime succ:(TIMSucc)succ fail:(TIMFail)fail;
-(void)getLocalConversationMessagesCallback:(void (^)(NSArray *array))block;
-(void)getMessageCallback:(void (^)(NSArray *array))block;
-(void)findMessagesCallback:(void (^)(NSArray *array))block;
-(void)getAllmessagesCallback:(void (^)(NSArray *array))block;
-(void)setMessageRead:(NSString*)messageId;
@end

//NS_ASSUME_NONNULL_END
