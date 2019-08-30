//
//  ARReportModel.m
//  MiniBuKe
//
//  Created by chenheng on 2019/6/20.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "ARReportModel.h"
#import "ARReportUDIDManager.h"
#import "ARReportEndTimeHandle.h"
@implementation ARReportModel
+(ARReportModel *)getModelWithEventId:(NSString *)eventId Detail:(NSString *)detail
{
    ARReportModel * model = [[ARReportModel alloc]init];
    model.groupId = [NSString stringWithFormat:@"%@",[ARReportUDIDManager singleton].uuid];
    model.eventId = eventId;
    model.detail = detail;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    model.startTime = timeString;
    NSDate * end = [dat dateByAddingTimeInterval:20];
    NSTimeInterval endtemp = [end timeIntervalSince1970];
    NSString * endString = [NSString stringWithFormat:@"%0.f", endtemp];//转为字符型
    model.endTime = endString;
    return model;
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"%@--%@--%@--%@",self.groupId,self.detail,self.startTime,self.endTime];
   
}
@end
