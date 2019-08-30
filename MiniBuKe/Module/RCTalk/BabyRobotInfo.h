//
//  BabyRobotInfo.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BabyRobotInfo : NSObject

@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *babyNickName;
@property(nonatomic,copy)NSString *babyBirthday;
@property(nonatomic,copy)NSString *deviceId;
@property(nonatomic,copy)NSString *babyImageUrl;
@property(nonatomic,assign)NSInteger babyGender;
@property(nonatomic,assign)NSInteger imTime;
@property(nonatomic,copy)NSString *babyQuestion;
@property(nonatomic,copy)NSString *superAbility;

+(BabyRobotInfo *)parseDataByDictionary:(NSDictionary *)dic;

@end
