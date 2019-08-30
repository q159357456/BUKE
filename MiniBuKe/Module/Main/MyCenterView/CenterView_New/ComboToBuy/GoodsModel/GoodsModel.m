//
//  GoodsModel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "GoodsModel.h"
#import "NSObject+Analytic.h"
@implementation GoodsModel

+(GoodsModel *)getGoodsInfo:(NSDictionary *)dic
{
    GoodsModel *model = (GoodsModel*)[GoodsModel AnalyticDic_Obj:dic];
    model.disCountDTOS = [DisCount AnalyticDic_Aarry:model.disCountDTOS];
    return model;
}

@end


@implementation DisCount

@end
