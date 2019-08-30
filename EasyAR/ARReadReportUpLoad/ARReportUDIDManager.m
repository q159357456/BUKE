//
//  ARReportUDIDManager.m
//  MiniBuKe
//
//  Created by chenheng on 2019/6/20.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "ARReportUDIDManager.h"
static NSString *  uuidcore = @"uuidLsitcore";
@implementation ARReportUDIDManager
static ARReportUDIDManager * _UDIDManager = nil;
#pragma mark - public
+(instancetype)singleton{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _UDIDManager = [[super allocWithZone:nil]init];
    });
    return _UDIDManager;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [ARReportUDIDManager singleton] ;
}

//添加
-(void)addUDID:(NSString*)UIDD{
    if (![self.udidSource containsObject:UIDD]) {
          [_udidSource addObject:UIDD];
        [[NSUserDefaults standardUserDefaults] setObject:[_udidSource copy] forKey:uuidcore];
        [[NSUserDefaults standardUserDefaults] synchronize];
//         NSLog(@"添加成功%@",UIDD);
        [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"ARReportUDIDManager添加成功%@",UIDD]];
    }
    
}
//删除
-(void)deletUDID:(NSString*)UIDD{
    if (self.udidSource.count) {
        if ([_udidSource containsObject:UIDD]){
            [_udidSource removeObject:UIDD];
            [[NSUserDefaults standardUserDefaults] setObject:[_udidSource copy] forKey:uuidcore];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            NSLog(@"ARReportUDIDManager%@ 删除成功",UIDD);
            [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"ARReportUDIDManager删除成功%@",UIDD]];
        }
    }
}

-(void)updateUDID{
    NSString * uuid = [[NSUUID UUID] UUIDString];
    [self addUDID:uuid];
    self.uuid = uuid;
}

-(NSMutableArray *)udidSource
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:uuidcore]) {
        _udidSource = [[[NSUserDefaults standardUserDefaults] objectForKey:uuidcore] mutableCopy];
    }
    if (_udidSource == nil) {
        _udidSource = [NSMutableArray array];
    }
    return _udidSource;
}
@end
