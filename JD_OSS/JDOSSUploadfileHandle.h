//
//  JDOSSUploadfileHandle.h
//  MiniBuKe
//
//  Created by chenheng on 2019/8/2.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDOSSUploadfileHandle : NSObject
+(void)JD_OSS_Initialize;
+(void)uploadFile:(NSString *)path Callback:(void(^)(NSString * ossAdress))callback;
+(void)uploadKbookFile:(NSString *)path Callback:(void (^)(NSString * _Nonnull))callback;
@end

NS_ASSUME_NONNULL_END
