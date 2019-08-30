//
//  VoiceUserInfo.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/9.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceUserInfo : NSObject

@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *userName;
@property(nonatomic,copy) NSString *nickName;
@property(nonatomic,copy) NSString *appellativeName;
@property(nonatomic,copy) NSString *passWord;
@property(nonatomic,copy) NSString *deviceId;
@property(nonatomic,copy) NSString *registerDate;
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,copy) NSString *updateTime;
@property(nonatomic,copy) NSString *imageUrl;
@property(nonatomic,copy) NSString *unionId;

@property(nonatomic,assign) NSInteger accountType;
@property(nonatomic,assign) NSInteger familyNumber;
@property(nonatomic,assign) NSInteger isDelete;
@property(nonatomic,assign) NSInteger voiceModel;
@property(nonatomic,assign) NSInteger updateBy;
@property(nonatomic,assign) NSInteger babyId;

@property(nonatomic,assign) NSInteger imTime;

+(VoiceUserInfo *)parseDataByDictionary:(NSDictionary *)dic;

@end
