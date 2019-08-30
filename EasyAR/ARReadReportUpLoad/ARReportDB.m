//
//  ARReportDB.m
//  MiniBuKe
//
//  Created by chenheng on 2019/6/20.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "ARReportDB.h"

@implementation ARReportDB
+(instancetype)defautManager{
    
    static dispatch_once_t onceToken;
    static ARReportDB *manager = nil;
    dispatch_once(&onceToken, ^{
        NSArray *documentArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        NSString *document = [documentArray objectAtIndex:0];
        NSString *filePath = [document stringByAppendingPathComponent:@"ARReportDBCore"];
        manager = [[ARReportDB alloc]initWithDBPath:filePath];
        //创建表
        BOOL success = [manager getTableCreatedWithClass:[ARReportModel class]];
        if (success) {
            NSLog(@"ARReportDBCore创建表成功");
        }else
        {
            
        }
    });
    
    return manager;
    
}


//插入数据
-(BOOL)insertARReportModel:(ARReportModel*)model{

    return [self insertToDB:model];
}

//查询数据
-(void)searchModelsWithUUID:(NSString*)UUID callback:(void (^)(NSMutableArray * array))block{

    NSString * condition = UUID.length?[NSString stringWithFormat:@"groupId='%@'",UUID]:nil;
    
    [self search:[ARReportModel class] where:condition orderBy:nil offset:0 count:MAXFLOAT callback:^(NSMutableArray * _Nullable array) {
        block(array);
    }];
    
}
//删数据
-(void)deleteModelsWithUUID:(NSString*)UUID callback:(void (^)(BOOL result))block{
    NSString * condition = UUID.length?[NSString stringWithFormat:@"groupId='%@'",UUID]:nil;
    [self deleteWithClass:[ARReportModel class] where:condition callback:^(BOOL result) {
        block(result);
    }];
}
//更新结束时间
-(BOOL)updateModelWithNewEndTimeModel:(ARReportModel*)model{

    if (!model) {
        return NO;
    }
    
    NSString * where = [NSString stringWithFormat:@"startTime='%@'",model.startTime];
    return [self updateToDB:model where:where];
   
}
@end
