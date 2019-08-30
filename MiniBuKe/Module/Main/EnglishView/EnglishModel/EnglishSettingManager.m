//
//  EnglishSettingManager.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EnglishSettingManager.h"

@implementation EnglishSettingManager
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static EnglishSettingManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[EnglishSettingManager alloc]init];
    });
    return manager;
}
@end
