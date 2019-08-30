//
//  FetchBannerPicService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpInterface.h"

typedef enum FetchBannerPicServiceType {
    FetchBannerPicServiceType_Book  = 2,
    FetchBannerPicServiceType_Story = 3
} FetchBannerPicServiceType;

@interface FetchBannerPicService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) NSMutableArray *array;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
      setFetchBannerPicServiceType:(FetchBannerPicServiceType) type;

@end
