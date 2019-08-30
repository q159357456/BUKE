//
//  StoryCollectService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface StoryCollectService : HttpInterface<HttpInterfaceDelegate>


//type: 0:收藏    1:取消收藏
-(id)initWithUerToken:(NSString *)token setStoryId:(NSString *)storyIds setType:(NSInteger )type setOnSuccess:(OnSuccess )onSuccessBock setOnError:(OnError)onErrorBock;

@end
