//
//  BabyRobotInfo.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BabyRobotInfo.h"

@implementation BabyRobotInfo

+(BabyRobotInfo *)parseDataByDictionary:(NSDictionary *)dic
{
    BabyRobotInfo *robotInfo = [[BabyRobotInfo alloc]init];
    if (dic != nil) {
        [robotInfo setValuesForKeysWithDictionary:dic];
       
    }
    
    return robotInfo;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.userId = value;
    }
}

-(void)setNilValueForKey:(NSString *)key
{
    [self setValue:@"" forKey:key];
}

@end
