//
//  KBookPageService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"
#import "KBookPageObject.h"

@interface KBookPageService : HttpInterface<HttpInterfaceDelegate>

@property(nonatomic,strong) KBookPageObject *bookPageObject;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
setBookId:(NSInteger )bookId
setPageNum:(NSInteger )pageNum
setGroupId:(NSInteger )groupId;

@end
