//
//  KBookListService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface KBookListService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,copy) NSArray *dataArray;

-(id) init:(OnSuccess) onSuccessBlock setOnError:(OnError) onErrorBlock setUSER_TOKEN:(NSString *) USER_TOKEN setPage:(NSInteger )page setPageNum:(NSInteger)pageNum;

@end
