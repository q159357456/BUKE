//
//  BookDetailService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@class BookDetailObject;

@interface BookDetailService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) BookDetailObject *mBookDetailObject;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
    setCid:(NSString *) mid;

@end
