//
//  UploadBabyAvatarService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/31.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpFormDataInterface.h"

@interface UploadBabyAvatarService : HttpFormDataInterface<HttpFormDataInterfaceDelegate>

@property(nonatomic,copy) NSString *ossImgUrl;

-(id) initWithImagePath:(NSString *)path setDeviceId:(NSString *)deviceId setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setToken:(NSString *)token;


@end
