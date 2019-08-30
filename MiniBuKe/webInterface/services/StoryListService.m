//
//  StoryListService.m
//  MiniBuKe
//
//  Created by Jim Wang on 2018/8/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryListService.h"
#import "StoryListModel.h"

@implementation StoryListService


-(id)initWithCategoryId:(NSString *)categoryId setPage:(NSInteger)page setPageNum:(NSInteger)pageNum setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        
        self.url = [NSString stringWithFormat:@"%@%@%@%@%ld%@%ld",SERVER_URL,@"/story/category/second/",categoryId,@"/",page,@"/",pageNum];
        NSLog(@"故事列表url====>%@",self.url);
       
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
        id StoryListObject = [dataDic objectForKey:@"StoryCategory"];
        
        if ([StoryListObject isKindOfClass:[NSArray class]]) {
            NSArray *storyListArray = (NSArray *)StoryListObject;
            self.storyListArray = [NSMutableArray array];
            for (NSDictionary *dic in storyListArray) {
                StoryListModel *listModel = [StoryListModel parseByDictionary:dic];
                [self.storyListArray addObject:listModel];
            }
        }
    }
}

-(NSMutableDictionary *)buildRequestParams
{
    return nil;
}

@end
