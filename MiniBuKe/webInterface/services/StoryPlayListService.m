//
//  StoryPlayListService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryPlayListService.h"
#import "StoryPlayListModel.h"
@implementation StoryPlayListService

-(id)initWithCategoryId:(NSInteger)categoryId setToken:(NSString *)token setType:(NSString *)type setPage:(NSInteger)page setPageNum:(NSInteger)pageNum setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        
        self.url = [NSString stringWithFormat:@"%@%@%ld/%@%@%ld%@%ld",SERVER_URL,@"/story/list/",categoryId,type,@"/",page,@"/",pageNum];
        NSLog(@"故事播放列表url====>%@",self.url);
        self.USER_TOKEN = token;
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

#pragma mark - HttpInterfaceDelegate
-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *responseDictinary = (NSDictionary *)responseJsonObject;
    id dataObject = [responseDictinary objectForKey:@"data"];
    
    if ([dataObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic = (NSDictionary *)dataObject;
        id StoryListObject = [dataDic objectForKey:@"StoryList"];
        
        if ([StoryListObject isKindOfClass:[NSArray class]]) {
            NSArray *storyListArray = (NSArray *)StoryListObject;
            self.storyPlayList = [NSMutableArray array];
            for (NSDictionary *dic in storyListArray) {
                StoryPlayListModel *listModel = [StoryPlayListModel parseByDictionary:dic];
                [self.storyPlayList addObject:listModel];
            }
        }
    }
}

-(NSMutableDictionary *)buildRequestParams
{
    return nil;
}

@end
