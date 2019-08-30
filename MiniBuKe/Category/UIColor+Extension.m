//
//  UIColor+Extension.m
//  UStudy
//
//  Created by pxh on 16/4/8.
//  Copyright © 2016年 上海云之声. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

/**
 *  从十六进色值中获取颜色
 */
+(UIColor* )colorWithHexStr:(NSString* )color{
    return [self colorWithHexStr:color alpha:1.f];
}
/**
 *  从十六进制中获取颜色 并设置alpha值
 */
+(UIColor* )colorWithHexStr:(NSString *)color alpha:(CGFloat )alpha{
    //删除字符串中的空格
    NSString* cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //String should be 6 or 8 characters
    if (cString.length < 6) {
        return [UIColor clearColor];
    }
    //strip 0X if it appears
    //如果是0x开头，那么截取字符串，字符串索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if (cString.length != 6) {
        return [UIColor clearColor];
    }
    //Separate into r,g,b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString* rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString* gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString* bString = [cString substringWithRange:range];
    //Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor
            colorWithRed:r / 255.0f
            green:g / 255.0f
            blue:b / 255.0f
            alpha:alpha];
}
/**
 *  通过颜色生成图片
 *
 *  @param color 图片的颜色
 *
 *  @return 生成的图片
 */
+(UIImage* )getImageFromColor:(UIColor* )color{
    CGRect rect = CGRectMake(0, 0, 8, 8);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  通过颜色生成图片
 *
 *  @param color 图片的颜色
 *  @param frame 生成图片的尺寸
 *
 *  @return 生成的图片
 */
+(UIImage* )getImageFromColor:(UIColor* )color frame:(CGRect)frame{
    CGRect rect = frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
