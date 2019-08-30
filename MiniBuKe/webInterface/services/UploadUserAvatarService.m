//
//  UploadUserAvatarService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "UploadUserAvatarService.h"

@interface UploadUserAvatarService()

@property(nonatomic,copy) NSString *path;

@end

@implementation UploadUserAvatarService

-(id)initWithImagePath:(NSString *)path setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setToken:(NSString *)token
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/user/uploadUserAvatar"];
        NSLog(@"上传头像url --- >%@",self.url);
        
        self.USER_TOKEN = token;
        self.path = path;
        
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    
    return self;
}

- (NSString *)requestFilePath
{
    NSLog(@"头像路径--->%@",self.path);
    return self.path;
}

-(NSMutableDictionary *)buildRequestParams
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:@"formData" forKey:@"type"];
    
    return dic;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *responseDic = (NSDictionary *)responseJsonObject;
    id responseId = [responseDic objectForKey:@"data"];
    if ([responseId isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic = (NSDictionary *)responseId;
        self.ossImgUrl = ![[dataDic objectForKey:@"url"] isKindOfClass:[NSNull class]] ? [dataDic objectForKey:@"url"] : @"";
        //self.ossImgUrl = [dataDic objectForKey:@"url"];
    }
}




@end
