//
//  SeriesList_Classify.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeriesList_Classify : NSObject
@property(nonatomic,copy)NSString *seriesName;
@property(nonatomic,copy)NSString *seriesType;
@property(nonatomic,strong)NSArray *xbkSeriesBookDtoList;
@property(nonatomic,assign)CGFloat rowHeight;
@property(nonatomic,copy)NSString *hasMore;
@property(nonatomic,strong)NSString *ageId;
+(NSArray *)getSeriesBookDtoList:(NSArray *)Aarray;
@end
