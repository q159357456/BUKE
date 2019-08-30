//
//  SeriesBookService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpInterface.h"

typedef enum SeriesBookServiceType {
    SeriesBookServiceType_My = 1,
    SeriesBookServiceType_Book  = 2,
    SeriesBookServiceType_Story = 3
} SeriesBookServiceType;

@interface SeriesBookService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
   setPage:(NSString *)page
setPageNum:(NSString *)pageNum
   setType:(SeriesBookServiceType)type
setSeriesType:(NSString *)seriesType;

@end
