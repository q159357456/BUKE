//
//  StoryCategoryService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface StoryCategoryService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) NSMutableArray *array;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock;

@end
