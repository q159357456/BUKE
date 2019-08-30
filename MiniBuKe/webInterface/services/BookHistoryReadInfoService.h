//
//  BookHistoryReadInfoService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@class BookHistoryReadInfo;

@interface BookHistoryReadInfoService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) BookHistoryReadInfo *mBookHistoryReadInfo;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN;

@end
