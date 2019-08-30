//
//  BKLog.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKLog.h"

@implementation BKLog

+(void)D:(NSString *)log{
    if(ISDEBUG){
        NSLog(@"");
    }
}
@end
