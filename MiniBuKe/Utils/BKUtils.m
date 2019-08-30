//
//  BKUtils.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKUtils.h"

@implementation BKUtils

+(int)dataToInt:(NSData *)data {
    Byte byte[4] = {};
    [data getBytes:byte length:4];
    int value;
    value = (int) (((byte[0] & 0xFF)<<24)
                   | ((byte[1] & 0xFF)<<16)
                   | ((byte[2] & 0xFF)<<8)
                   | (byte[3] & 0xFF));
    
    return value;
}


+(void)showHUDToast:(UIView *)attachView text:(NSString *)tips{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:attachView animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud.label setText:tips];
    hud.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-60);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:attachView animated:YES];
    });
}

+(BOOL)isEmpty:(NSString*)value{
    return [value  isEqualToString:@""];
}

+(BOOL)checkPhoneFormat:(NSString *)phone{
    return YES;
}


+(NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}


+(UIImage*)createImageWithColor:(UIColor*)color{
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}

/**检测大陆港澳台手机号码合法性*///11-23
+(BOOL)checkPhoneNumberIsValidity:(NSString*)phoneNumber withAreaPhone:(NSString*)areaNumber{
    if ([areaNumber isEqualToString:@"+86"]) {
        return [self validateCellPhoneNumber:phoneNumber];
    }else if ([areaNumber isEqualToString:@"+852"]){//香港
        return [self validateCellHKAreaPhoneNumber:phoneNumber];
    }else if ([areaNumber isEqualToString:@"+853"]){//澳门
        return [self validateCellAMAreaPhoneNumber:phoneNumber];
    }else if ([areaNumber isEqualToString:@"+886"]){//台湾
        return [self validateCellTWAreaPhoneNumber:phoneNumber];
    }
    return NO;
}

+ (BOOL)validateCellPhoneNumber:(NSString *)cellNum{
    if (cellNum.length != 11) {
        return NO;
    }
    NSString*isChinaMobile = @"^134[0-8]\\d{7}$|^(?:13[5-9]|147|15[0-27-9]|178|1703|1705|1706|18[2-478])\\d{7,8}$"; //移动
    NSString*isChinaUniom = @"^(?:13[0-2]|145|15[56]|176|1704|1707|1708|1709|171|18[56])\\d{7,8}|$"; //联通
    NSString*isChinaTelcom = @"^(?:133|153|1700|1701|1702|177|173|18[019])\\d{7,8}$";//电信
    NSString *new = @"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isChinaMobile];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isChinaUniom];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isChinaTelcom];
    NSPredicate *regextestctnew = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", new];
    
    if(([regextestcm evaluateWithObject:cellNum] == YES)
       || ([regextestct evaluateWithObject:cellNum] == YES)
       || ([regextestcu evaluateWithObject:cellNum] == YES)
       || ([regextestctnew evaluateWithObject:cellNum] == YES)
      ){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)validateCellHKAreaPhoneNumber:(NSString *)cellNum{
    
    NSString*isHongKong = @"^(5|6|8|9)\\d{7}$"; //香港
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isHongKong];
    
    if([regextestcm evaluateWithObject:cellNum] == YES
       ){
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)validateCellAMAreaPhoneNumber:(NSString *)cellNum{
    NSString*isAoMen = @"^[6]\\d{8}$";//澳门
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isAoMen];
    
    if([regextestct evaluateWithObject:cellNum] == YES
       ){
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)validateCellTWAreaPhoneNumber:(NSString *)cellNum{
    NSString*istTaiWang = @"^([0][9])\\d{8}$"; //台湾
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", istTaiWang];
    
    if([regextestcu evaluateWithObject:cellNum] == YES)
    {
        return YES;
    }else{
        return NO;
    }
}
@end
