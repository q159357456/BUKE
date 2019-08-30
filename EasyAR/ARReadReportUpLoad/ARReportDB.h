//
//  ARReportDB.h
//  MiniBuKe
//
//  Created by chenheng on 2019/6/20.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LKDBHelper.h>
#import "ARReportModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ARReportDB : LKDBHelper
+(instancetype)defautManager;
//插入数据
-(BOOL)insertARReportModel:(ARReportModel*)model;
//查询数据
-(void)searchModelsWithUUID:(NSString*)UUID callback:(void (^)(NSMutableArray * array))block;
//删数据
-(void)deleteModelsWithUUID:(NSString*)UUID callback:(void (^)(BOOL result))block;
//更新结束时间
-(BOOL)updateModelWithNewEndTimeModel:(ARReportModel*)model;
@end

NS_ASSUME_NONNULL_END
