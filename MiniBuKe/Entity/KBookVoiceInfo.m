//
//  KBookVoiceInfo.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookVoiceInfo.h"

@implementation KBookVoiceInfo


+(KBookVoiceInfo *)parseDataByDictionary:(NSDictionary *)dic
{
    KBookVoiceInfo *kbookInfo = nil;
    if (dic != nil) {
        kbookInfo = [[KBookVoiceInfo alloc] init];
        [kbookInfo setValuesForKeysWithDictionary:dic];
    }
    
    return kbookInfo;
}

-(void)setNilValueForKey:(NSString *)key
{
    [self setValue:@"" forKey:key];
}


@end
