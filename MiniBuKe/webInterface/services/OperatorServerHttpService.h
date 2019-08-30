//
//  OperatorServerHttpService.h
//  JTShopManage
//
//  Created by ren fei on 13-10-8.
//  Copyright (c) 2013年 JTShopManage. All rights reserved.
//

#import "HttpInterface.h"

@interface OperatorServerHttpService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) NSMutableArray *netList;

-(id) init:(NSString *) identification
setPassword:(NSString *) password
setOnSuccess:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock;

@end
