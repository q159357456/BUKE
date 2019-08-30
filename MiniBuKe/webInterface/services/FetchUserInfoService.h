//
//  FetchUserInfoService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@class FetchUserInfo;

@interface FetchUserInfoService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) FetchUserInfo *mFetchUserInfo;

-(id) init:(OnSuccess) onSuccessBlock
    setOnError:(OnError) onError
setUserToken:(NSString *) userToken;


@end
