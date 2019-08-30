//
//  UpBabyInfo.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/31.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "UpBabyInfo.h"
#import "OJBabyInfoUpLoadService.h"
@implementation UpBabyInfo
-(void)upLoad:(NSDictionary*)dic Success:(OnSuccess)success Fail:(OnError)fail
{
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"获取分类 ==> OnSuccess");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"上传信息成功!"];
        success(httpInterface,description);
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"LoginService ==> OnError");
        fail(httpInterface,description);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:description];
    };
    
    OJBabyInfoUpLoadService *service = [[OJBabyInfoUpLoadService  alloc] initWithOnSuccess:OnSuccess setOnError:OnError setToken:APP_DELEGATE.mLoginResult.token setDictionary:dic];
    [service start];
    
}
@end
