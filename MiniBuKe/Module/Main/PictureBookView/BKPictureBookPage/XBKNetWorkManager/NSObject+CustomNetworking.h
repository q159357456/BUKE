//
//  NSObject+CustomNetworking.h
//  PictureBook
//
//  Created by Don on 2018/5/7.
//  Copyright © 2018年 Don. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum : NSInteger{
    BKRequestType_Get,
    BKRequestType_Post,
    BKRequestType_Delete
}BKRequestType;

@interface NSObject (CustomNetworking)

+ (instancetype)RequestNetWithType:(BKRequestType)requestType tokenFlag:(NSString*)tokenFlagstr Path:(NSString *)path parameters:(NSDictionary *)parameters isCache:(BOOL)isCache  withTime:(float)time progress:(void(^)(NSProgress *downloadProgress))downloadProgress completionHandler:(void(^)(id responseObj, NSError *error))completionHandler;

+ (instancetype)RequestPostPicWithType:(NSArray*)array Path:(NSString *)path parameters:(NSDictionary *)parameters isCache:(BOOL)isCache  withTime:(float)time progress:(void(^)(NSProgress *downloadProgress))downloadProgress completionHandler:(void(^)(id responseObj, NSError *error))completionHandler;

/**
 封装AF网络请求接口:
 token标识(tokenFlag):传tokenFlagAuthorization或者tokenFlagUSER_TOKEN 不带token接口传空@""
 */
+ (void)RequestNetAndIsJSONParameter:(BOOL)IsJSONParameter With:(BKRequestType)requestType tokenFlag:(NSString*)tokenFlagstr Path:(NSString *)path parameters:(NSDictionary *)parameters isCache:(BOOL)isCache  withTime:(float)time progress:(void(^)(NSProgress *downloadProgress))downloadProgress completionHandler:(void(^)(id responseObj, NSError *error))completionHandler;

@end
