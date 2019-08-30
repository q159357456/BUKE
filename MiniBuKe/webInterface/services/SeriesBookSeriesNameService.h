//
//  SeriesBookSeriesNameService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

typedef enum SeriesBookSeriesNameServiceType {
    SeriesBookSeriesNameServiceType_My = 1,
    SeriesBookSeriesNameServiceType_Book  = 2,
    SeriesBookSeriesNameServiceType_Story = 3
} SeriesBookSeriesNameServiceType;

@interface SeriesBookSeriesNameService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
    setType:(SeriesBookSeriesNameServiceType ) type;

@end
