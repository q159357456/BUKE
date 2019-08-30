//
//  StoryPlayListService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface StoryPlayListService : HttpInterface<HttpInterfaceDelegate>

//存放storyPlayListModel
@property(nonatomic,strong)NSMutableArray *storyPlayList;

-(id)initWithCategoryId:(NSInteger )categoryId setToken:(NSString *)token setType:(NSString *)type setPage:(NSInteger)page setPageNum:(NSInteger)pageNum setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock;

@end
