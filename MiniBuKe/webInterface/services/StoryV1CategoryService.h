//
//  StoryV1CategoryService.h
//  MiniBuKe
//
//  Created by Jim Wang on 2018/8/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface StoryV1CategoryService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) NSMutableArray *array;

-(id) init:(OnSuccess) onSuccessBlock setOnError:(OnError) onErrorBlock;


@end
