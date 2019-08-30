//
//  KbookUploadService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/7/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpFormDataInterface.h"

@interface KbookUploadService : HttpFormDataInterface<HttpFormDataInterfaceDelegate>


@property(nonatomic,copy) NSString *ossUrl;

-(id)initWithPath:(NSString *)path BookId:(NSString *)bookId UserId:(NSString *)userId setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock;


@end
