//
//  SeriesOfBooks.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/8.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeriesBookService.h"

@class SeriesListObject;

@interface SeriesOfBooks : UIView

-(instancetype)initWithFrame:(CGRect)frame setSeriesListObject:(SeriesListObject *) mSeriesListObject setType:(SeriesBookServiceType) mSeriesBookServiceType;

-(void) updateData:(NSArray *) dataArray;

@end
