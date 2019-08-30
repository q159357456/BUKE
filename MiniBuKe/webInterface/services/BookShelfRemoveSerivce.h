//
//  BookShelfRemoveSerivce.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface BookShelfRemoveSerivce : HttpInterface<HttpInterfaceDelegate>

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
setIds:(NSString *) ids;

@end
