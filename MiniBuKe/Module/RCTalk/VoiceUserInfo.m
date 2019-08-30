//
//  VoiceUserInfo.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/9.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "VoiceUserInfo.h"

@implementation VoiceUserInfo

+(VoiceUserInfo *)parseDataByDictionary:(NSDictionary *)dic
{
    VoiceUserInfo *info;
    if (dic != nil) {
        info = [[VoiceUserInfo alloc]init];
        [info setValuesForKeysWithDictionary:dic];
    }
    
    return info;
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
