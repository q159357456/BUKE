//
//  NSString+DES.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DES)

+(NSString *)des:(NSString *)str key:(NSString *)key;

+(NSString *)decryptDes:(NSString*)str key:(NSString*)key;

@end
