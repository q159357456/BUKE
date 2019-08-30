//
//  KBookDeleteService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/6/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface KBookDeleteService : HttpInterface<HttpInterfaceDelegate>

-(id) initWithOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setToken:(NSString *)token setBookId:(NSInteger )bookId;



@end
