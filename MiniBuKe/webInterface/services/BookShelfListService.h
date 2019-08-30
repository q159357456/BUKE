//
//  BookShelfListService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface BookShelfListService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
   setPage:(NSString *) page
setPageNum:(NSString *) pageNum;

@end
