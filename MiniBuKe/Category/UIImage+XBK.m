//
//  UIImage+XBK.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "UIImage+XBK.h"

@implementation UIImage (XBK)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
