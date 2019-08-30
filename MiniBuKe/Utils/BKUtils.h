//
//  BKUtils.h
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

@interface BKUtils : NSObject
+(int)dataToInt:(NSData *)data ;

+(BOOL)isEmpty:(NSString*)value;

+(BOOL)checkPhoneFormat:(NSString*)phone;

+(NSString *)iphoneType;

+(UIImage*)createImageWithColor:(UIColor*)color;

+(void)showHUDToast:(UIView *)attachView text:(NSString *)tips;

/**检测大陆港澳台手机号码合法性*///11-23
+(BOOL)checkPhoneNumberIsValidity:(NSString*)phoneNumber withAreaPhone:(NSString*)areaNumber;

@end
