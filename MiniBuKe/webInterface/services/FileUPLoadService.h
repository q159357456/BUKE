//
//  FileUploadService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/8.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpFormDataInterface.h"

@interface FileUploadService : HttpFormDataInterface<HttpFormDataInterfaceDelegate>


@property(nonatomic,copy) NSString *ossUrl;

-(id)initWithPath:(NSString *)path setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock;


@end
