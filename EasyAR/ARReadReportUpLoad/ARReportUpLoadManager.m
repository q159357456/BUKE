//
//  ARReportUpLoadManager.m
//  MiniBuKe
//
//  Created by chenheng on 2019/6/21.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "ARReportUpLoadManager.h"
#import "ARReportDB.h"
#import "ARReportUDIDManager.h"
@implementation ARReportUpLoadManager
+(void)uploadReport{
    NSArray * tempArray = [[ARReportUDIDManager singleton].udidSource copy];
    if (tempArray.count) {
        NSLog(@"udid_list %@",tempArray);
        [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"udid_list %@",tempArray]];
        for (NSString * uuid in tempArray) {
            NSMutableArray * dataarray = [NSMutableArray array];
            [[ARReportDB defautManager] searchModelsWithUUID:uuid callback:^(NSMutableArray * _Nonnull array) {
                for (ARReportModel * model in array) {
//                    NSLog(@"上传的数据===>%@",model.description);
                    [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"上传的数据: %@",model.description]];
                    NSDictionary * dic = [model mj_keyValues];
                    [dataarray addObject:dic];
                }
                if (dataarray.count) {
                    [XBKNetWorkManager eventReportBookWithList:dataarray Finish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                        NSDictionary *dic = (NSDictionary*)responseObj;
                        if ([dic[@"code"] integerValue] == 1) {

//                            NSLog(@"%@ ==> 上报成功",uuid);
                            [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"上报成功%@",uuid]];
                            [[ARReportDB defautManager] deleteModelsWithUUID:uuid callback:^(BOOL result) {
//                                NSLog(@"%@  ==>从ARReportDB删除成功",uuid);
                                [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"ARReportDB删除成功%@",uuid]];
                                [[ARReportUDIDManager singleton] deletUDID:uuid];
                            }];

                        }else
                        {
                            NSLog(@"上报错误 ==>%@%@",uuid,dic[@"msg"]);
                            [MonitorLogView showMonitorLog:[NSString stringWithFormat:@"上报错误 %@%@",uuid,dic[@"msg"]]];

                        }
                    }];
                }
            }];
        }
    }
    
   
}
@end
