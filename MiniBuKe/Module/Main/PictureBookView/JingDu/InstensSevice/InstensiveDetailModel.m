//
//  InstensiveDetailModel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "InstensiveDetailModel.h"
#import "NSObject+Analytic.h"
@implementation InstensiveDetailModel
+(InstensiveDetailModel  *)getIntensiveDetail:(NSDictionary *)dic
{
    InstensiveDetailModel *model = (InstensiveDetailModel*)[InstensiveDetailModel AnalyticDic_Obj:dic];
    
    model.columnBookList = [IntensiveBookModel AnalyticDic_Aarry:model.columnBookList];
    return model;
    
}

@end

@implementation IntensiveBookModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.bookId = value;
    }
}

@end
