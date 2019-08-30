//
//  AboutService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface AboutService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN;

@end
