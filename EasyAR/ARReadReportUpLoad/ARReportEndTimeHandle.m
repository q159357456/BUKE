//
//  ARReportEndTimeHandle.m
//  MiniBuKe
//
//  Created by chenheng on 2019/6/21.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "ARReportEndTimeHandle.h"
#import "ARReportDB.h"
@implementation ARReportEndTimeHandle
static ARReportEndTimeHandle * _EndTimeHandle = nil;
#pragma mark - public
+(instancetype)singleton{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _EndTimeHandle = [[super allocWithZone:nil]init];
    });
    return _EndTimeHandle;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [ARReportEndTimeHandle singleton];
}
-(void)restoration{
    
    self.lastReportModel = nil;
}
-(void)updateEndTime
{
    if (self.lastReportModel) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转
        self.lastReportModel.endTime = timeString;
        if ([[ARReportDB defautManager] updateModelWithNewEndTimeModel:self.lastReportModel]) {
            NSLog(@"%@ ===> 更新成功",self.lastReportModel.groupId);
        }else
        {
            NSLog(@"%@ ===> 更新失败",self.lastReportModel.groupId);
        }
    }
}
@end
