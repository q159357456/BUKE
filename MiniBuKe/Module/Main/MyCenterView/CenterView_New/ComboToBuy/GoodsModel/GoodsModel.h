//
//  GoodsModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsModel : NSObject
@property(nonatomic,strong)NSArray *disCountDTOS;
@property(nonatomic,strong)NSString *goodsContext;
@property(nonatomic,strong)NSString *goodsId;
@property(nonatomic,strong)NSString *goodsName;
@property(nonatomic,strong)NSString *goodsPic;
@property(nonatomic,strong)NSString *goodsPrice;
+(GoodsModel*)getGoodsInfo:(NSDictionary*)dic;
@end


@interface DisCount : NSObject
@property(nonatomic,strong)NSString *diaName;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *userDisId;
@end
NS_ASSUME_NONNULL_END
