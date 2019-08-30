//
//  NSDate+XBK.m
//  MiniBuKe
//
//  Created by chenheng on 2018/7/9.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "NSDate+XBK.h"

@implementation NSDate (XBK)

-(BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    //获得self 的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    if (selfCmps.year == nowCmps.year && selfCmps.month == nowCmps.month && selfCmps.day == nowCmps.day) {
        return YES;
    }
    
    return NO;
}

-(BOOL)isYesterday
{
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    NSDate *selfDate = [self dateWithYMD];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.day == 1;
}

- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}


-(NSDate *)dateWithYMD
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [formatter stringFromDate:self];
    
    return [formatter dateFromString:selfStr];
}

-(NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    int unit = NSCalendarUnitSecond;

    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

-(NSString*)DateTransformTimeStr{
    if ([self isToday]) {
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"今天HH:mm"];
        return  [dateFormat stringFromDate:self];
    }else if ([self isYesterday]){
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"昨天HH:mm"];
        return  [dateFormat stringFromDate:self];
    }else if ([self isThisYear]){
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"MM-dd"];
        return [dateFormat stringFromDate:self];
    }
    else{
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        return [dateFormat stringFromDate:self];
    }
}

-(NSString*)DateTransformTimeShuoshuoStr{
    
    if ([self isToday]) {
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"HH:mm"];
        return  [dateFormat stringFromDate:self];
    }else if ([self isYesterday]){
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"昨天HH:mm"];
        return  [dateFormat stringFromDate:self];
    }else if ([self isThisYear]){
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"MM-dd"];
        return [dateFormat stringFromDate:self];
    }
    else{
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        return [dateFormat stringFromDate:self];
    }
}
@end
