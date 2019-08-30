//
//  NSDate+XBK.h
//  MiniBuKe
//
//  Created by chenheng on 2018/7/9.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

/***  使用方法
 
 * NSDateFormatter *formater = [[NSDateFormatter alloc] init];
 
 * formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
 
 * NSDate *sendDate  = [formater dateFromString:@"你想判断的时间"];
 
 * sendDate.isToday  //判断是否为今日
 * sendDate.isThisYear //判断是否为昨日
 
 * sendDate.isYesterday  //判断是否为今年
 
 * 还有一个是获取与当前时间差距的方法deltaWithNow
 
 **/



#import <Foundation/Foundation.h>

@interface NSDate (XBK)

/**
 *  是否为今天
 */
-(BOOL)isToday;

/**
 *  是否为昨天
 */
-(BOOL)isYesterday;

/**
 *  是否为今年
 */
-(BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
-(NSDate *)dateWithYMD;


/**
 *  获得与当前时间的差距
 */
-(NSDateComponents *)deltaWithNow;


/**
 *  获得特殊显示日期字符串(今天12:12,昨天12:12,12-12,2017-12-23)
 *  消息列表时间样式
 */
-(NSString*)DateTransformTimeStr;
-(NSString*)DateTransformTimeShuoshuoStr;
@end
