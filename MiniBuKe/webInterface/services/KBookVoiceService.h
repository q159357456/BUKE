//
//  KBookVoiceService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/6/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface KBookVoiceService : HttpInterface<HttpInterfaceDelegate>

@property(nonatomic,copy) NSArray *kbookArray;

-(id) init:(OnSuccess) onSuccessBlock setOnError:(OnError) onErrorBlock setBookId:(NSString *)bookId setToken:(NSString *)token;


@end
