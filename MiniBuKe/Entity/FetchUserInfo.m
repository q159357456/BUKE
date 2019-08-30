//
//  FetchUserInfo.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "FetchUserInfo.h"

@implementation FetchUserInfo


+(FetchUserInfo *) objectWithDic:(NSDictionary *) dic
{
//    @property (nonatomic,strong) NSString *mId;//"id": 208,
//    @property (nonatomic,strong) NSString *userName;//"userName": "15920090504",
//    @property (nonatomic,strong) NSString *passWord;
//    @property (nonatomic,strong) NSString *accountType;
//    @property (nonatomic,strong) NSString *nickName;
//    @property (nonatomic,strong) NSString *appellativeName;
//    @property (nonatomic,strong) NSString *deviceId;
//    @property (nonatomic,strong) NSString *registerDate;
//    @property (nonatomic,strong) NSString *familyNumber;
//    @property (nonatomic,strong) NSString *babyId;
    
//    @property (nonatomic,strong) NSString *isDelete;
//    @property (nonatomic,strong) NSString *createTime;
//    @property (nonatomic,strong) NSString *updateTime;
//    @property (nonatomic,strong) NSString *imageUrl;
//    @property (nonatomic,strong) NSString *unionId;
//    @property (nonatomic,strong) NSString *voiceModel;
//    @property (nonatomic,strong) NSString *robotVersion;
//    @property (nonatomic,strong) NSString *imTime;
    
    FetchUserInfo *obj = nil;
    if (dic != nil) {
        obj = [[FetchUserInfo alloc] init];
        
        obj.mId = ![[dic objectForKey:@"id"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"id"]stringValue] : @"";
        obj.userName = ![[dic objectForKey:@"userName"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"userName"] : @"";
        obj.passWord = ![[dic objectForKey:@"passWord"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"passWord"] : @"";
        obj.accountType = ![[dic objectForKey:@"accountType"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"accountType"] : @"";
        obj.nickName = ![[dic objectForKey:@"nickName"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"nickName"] : @"";
        obj.appellativeName = ![[dic objectForKey:@"appellativeName"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"appellativeName"] : @"";
        obj.deviceId = ![[dic objectForKey:@"deviceId"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"deviceId"] : @"";
        obj.registerDate = ![[dic objectForKey:@"registerDate"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"registerDate"] : @"";
        obj.updateTime = ![[dic objectForKey:@"updateTime"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"updateTime"] : @"";
        obj.familyNumber = ![[dic objectForKey:@"familyNumber"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"familyNumber"] : @"";
        obj.babyId = ![[dic objectForKey:@"babyId"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"babyId"] : @"";
        
        obj.isDelete = ![[dic objectForKey:@"isDelete"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"isDelete"] : @"";
        obj.createTime = ![[dic objectForKey:@"createTime"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"createTime"] : @"";
        obj.updateTime = ![[dic objectForKey:@"updateTime"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"updateTime"] : @"";
        obj.imageUrl = ![[dic objectForKey:@"imageUrl"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"imageUrl"] : @"";
        obj.unionId = ![[dic objectForKey:@"unionId"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"unionId"] : @"";
        obj.voiceModel = ![[dic objectForKey:@"voiceModel"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"voiceModel"] : @"";
        obj.robotVersion = ![[dic objectForKey:@"robotVersion"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"robotVersion"] : @"";
        obj.imTime = ![[dic objectForKey:@"imTime"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"imTime"] : @"";
        
        NSLog(@"FetchUserInfo ==> mid = %@ || appellativeName = %@ ",obj.mId,obj.appellativeName);
    }
    
    return obj;
}
@end
