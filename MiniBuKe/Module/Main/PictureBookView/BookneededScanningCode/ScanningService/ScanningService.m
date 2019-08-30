//
//  ScanningService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ScanningService.h"
#import "NSObject+CustomNetworking.h"
#import "NSObject+Analytic.h"
@implementation ScanningService
+(instancetype)BookRegister:(NSString*)isbn :(void(^)(BookStatusModle *model,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@/book/register/info/%@",SERVER_URL,isbn];
    NSLog(@"ScanningService===>%@",path);
    return [self RequestNetWithType:BKRequestType_Get tokenFlag:tokenFlagUSER_TOKEN  Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        NSDictionary *dic = (NSDictionary*)responseObj;
        completionHandler((BookStatusModle*)[BookStatusModle AnalyticDic_Obj:dic[@"data"][@"registerBook"]],error);
    }];
    
}
@end


