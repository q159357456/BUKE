//
//  UIColor+Extension.h
//  UStudy
//
//  Created by zhangchunzhe on 2018/2/24.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/**
 *  RGB 颜色读取
 */
#undef PXH_RGBA
#define PXH_RGBA_COLOR(R,G,B,A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

#undef PXH_RGB
#define PXH_RGB_COLOR(R,G,B)    [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

/**
 *  从十六进色值中获取颜色
 */
+(UIColor* )colorWithHexStr:(NSString* )color;
/**
 *  从十六进制中获取颜色 并设置alpha值
 */
+(UIColor* )colorWithHexStr:(NSString *)color alpha:(CGFloat )alpha;
/**
 *  通过颜色生成图片
 *
 *  @param color 图片的颜色
 *
 *  @return 生成的图片
 */
+(UIImage* )getImageFromColor:(UIColor* )color;

/**
 *  通过颜色生成图片
 *
 *  @param color 图片的颜色
 *  @param frame 生成图片的尺寸
 *
 *  @return 生成的图片
 */
+(UIImage* )getImageFromColor:(UIColor* )color frame:(CGRect)frame;

@end
