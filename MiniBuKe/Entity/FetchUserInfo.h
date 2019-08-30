//
//  FetchUserInfo.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchUserInfo : NSObject
//"user": {
@property (nonatomic,strong) NSString *mId;//"id": 208,
@property (nonatomic,strong) NSString *userName;//"userName": "15920090504",
@property (nonatomic,strong) NSString *passWord;
@property (nonatomic,strong) NSString *accountType;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *appellativeName;
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *registerDate;
@property (nonatomic,strong) NSString *familyNumber;
@property (nonatomic,strong) NSString *babyId;
@property (nonatomic,strong) NSString *isDelete;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *unionId;
@property (nonatomic,strong) NSString *voiceModel;
@property (nonatomic,strong) NSString *robotVersion;
@property (nonatomic,strong) NSString *imTime;

+(FetchUserInfo *) objectWithDic:(NSDictionary *) dic;
@end
