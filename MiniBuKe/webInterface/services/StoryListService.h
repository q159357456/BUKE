//
//  StoryListService.h
//  MiniBuKe
//
//  Created by Jim Wang on 2018/8/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface StoryListService : HttpInterface<HttpInterfaceDelegate>

@property(nonatomic,strong)NSMutableArray *storyListArray;

-(id)initWithCategoryId:(NSString *)categoryId  setPage:(NSInteger)page setPageNum:(NSInteger)pageNum setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock;

@end
