//
//  BookListCategoryIdService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface BookListCategoryIdService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setCid:(NSString *) cid
   setPage:(NSString *)page
setPageNum:(NSString *)pageNum;

@end
