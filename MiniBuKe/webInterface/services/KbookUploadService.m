//
//  KbookUploadService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/7/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KbookUploadService.h"

@interface  KbookUploadService()

@property(nonatomic,copy) NSString *filePath;

@end


@implementation KbookUploadService

-(id)initWithPath:(NSString *)path BookId:(NSString *)bookId UserId:(NSString *)userId setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        
        self.url = [NSString stringWithFormat:@"%@%@?bookId=%@&userId=%@",SERVER_URL,@"/file/kBook/upload",bookId,userId];
        self.filePath = path;
        
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    
    return self;
}

#pragma mark - HttpFormDataInterfaceDelegate
-(NSString *)requestFilePath
{
    return self.filePath;
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
        self.ossUrl = [dataDic objectForKey:@"url"];
    }
}

@end
