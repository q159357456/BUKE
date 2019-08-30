//
//  AboutInfo.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AboutInfo : NSObject

@property (nonatomic,strong) NSString *mid;
@property (nonatomic,strong) NSString *infoName;
@property (nonatomic,strong) NSString *showType;
@property (nonatomic,strong) NSString *infoValue;
@property (nonatomic,strong) NSString *infoLink;
@property (nonatomic,strong) NSString *sortNum;
@property (nonatomic,strong) NSString *isDelete;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,strong) NSString *createBy;
@property (nonatomic,strong) NSString *updateBy;

+(AboutInfo *) withObject:(NSDictionary *) dic;
//"id": 3,
//"infoName": "官方网站",
//"showType": 2,
//"infoValue": "http://www.oplushome.com",
//"infoLink": "http://www.oplushome.com",
//"sortNum": 1,
//"isDelete": 0,
//"createTime": 1523688000000,
//"updateTime": 1523688000000,
//"createBy": 1,
//"updateBy": 1

@end
