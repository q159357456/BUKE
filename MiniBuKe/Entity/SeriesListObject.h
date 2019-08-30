//
//  SeriesListObject.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeriesListObject : NSObject

//"seriesName": "系列1",
//"seriesType": 1
@property (nonatomic,strong) NSString *seriesName;
@property (nonatomic,strong) NSString *seriesType;

+(SeriesListObject *) withObject:(NSDictionary *) dic;

@end
