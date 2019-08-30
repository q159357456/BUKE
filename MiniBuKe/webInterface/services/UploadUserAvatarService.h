//
//  UploadUserAvatarService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpFormDataInterface.h"

@interface UploadUserAvatarService : HttpFormDataInterface<HttpFormDataInterfaceDelegate>


@property(nonatomic,copy) NSString *ossImgUrl;

-(id) initWithImagePath:(NSString *)path setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setToken:(NSString *)token;

@end
