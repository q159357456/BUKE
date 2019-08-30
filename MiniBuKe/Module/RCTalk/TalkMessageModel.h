//
//  TalkMessageModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  消息发送类型
 */
typedef NS_ENUM(NSUInteger,MessageSenderType) {
    MessageSenderTypeSelf,//自己发送的消息
    MessageSenderTypeRobot,//机器人发来的消息
    MessageSenderTypeOther,//其它人发送的消息
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger, MessageType){
    MessageTypeText,          // 文字
    MessageTypeImage,         // 图片
    MessageTypeVoice,         // 语音
};

/**
 *  消息发送状态
 */
typedef NS_ENUM(NSInteger, MessageSentStatus){
    MessageSentStatusSended = 1,//送达
    MessageSentStatusUnSended, //未发送
    MessageSentStatusSending, //正在发送
};

/**
 *  消息接收状态
 */
typedef NS_ENUM(NSInteger, MessageReadStatus){
    MessageReadStatusRead = 1,//消息已读
    MessageReadStatusUnRead,//消息未读
};


@interface TalkMessageModel : NSObject<NSCoding>

@property(nonatomic, assign)MessageSenderType      messageSenderType;
@property(nonatomic, assign)MessageType            messageType;
@property (nonatomic, assign)MessageSentStatus     messageSentStatus;
@property (nonatomic, assign)MessageReadStatus     messageReadStatus;

@property(nonatomic) int mId;
//是否显示时间
@property(nonatomic, assign)BOOL     showMessageTime;
//消息时间  2017-09-11 11:11
@property(nonatomic, copy)NSString   *messageTime;

//是否显示昵称
@property(nonatomic, assign)BOOL     showNickName;
@property(nonatomic, copy)NSString   *nickName;

//头像
@property (nonatomic, copy)NSString  *logoUrl;

/*
 消息文本内容
 */
@property (nonatomic, retain) NSString    *messageText;

//音频时间
@property(nonatomic, assign)NSUInteger     duringTime;

/*
 消息音频url
 */
@property (nonatomic, retain) NSString    *voiceUrl;

/**
 图片url
 */
@property (nonatomic, retain) NSString *imageUrl;

/**
 图片文件
 */
@property(nonatomic, strong) UIImage *imageSmall;

@end
