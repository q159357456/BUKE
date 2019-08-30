//
//  NSData+DataToHexString.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "NSData+DataToHexString.h"

@implementation NSData (DataToHexString)

-(NSString *)dataToHexString{
    NSUInteger len = [self length];
    char *chars = (char *)[self bytes];
    NSMutableString *hexString = [[NSMutableString alloc]init];
    for (NSUInteger i=0; i<len; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx",chars[i]]];
    }
    return hexString;
}

@end
