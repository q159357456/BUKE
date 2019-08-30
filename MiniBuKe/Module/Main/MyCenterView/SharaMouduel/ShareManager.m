//
//  ShareManager.m
//  MiniBuKe
//
//  Created by chenheng on 2019/7/24.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "ShareManager.h"
#import "ShareURLView.h"
#import "ShareContentView.h"
#import "ShareChooseView.h"
#import "ShareMinProj.h"
@interface ShareManager()
@property(nonatomic,strong)ShareContentView * shareContentView;
@property(nonatomic,strong)ShareURLView * shareURLView;
@property(nonatomic,strong)WKWebView * webView;
@property(nonatomic,assign)NSInteger tag;
@end
static ShareManager * _shareManager = nil;
@implementation ShareManager

+(instancetype)singleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [super allocWithZone:nil];
    });
    return _shareManager;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [ShareManager singleton];
}
-(void)getTemplate:(NSInteger)tag WebView:(WKWebView*)webView
{
    
    [MBProgressHUD showMessage:@"" toView:webView];
    switch (tag) {
        case 1:
        {
            self.webView = webView;
            self.tag = tag;
            [webView evaluateJavaScript:@"getShareArguments(3)" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@"result:%@",result);
                NSLog(@"error:%@",error);
            }];
         
        }
            break;
            
        case 2:
        {
            self.webView = webView;
            self.tag = tag;
            [webView evaluateJavaScript:@"getShareArguments(2)" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                
            }];
     
           
        }
            break;
            
        case 3:
        {
            self.webView = webView;
            self.tag = tag;
            [webView evaluateJavaScript:@"getShareArguments(1)" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                
            }];
       
        }
            break;
            
        default:
            break;
    }
    
   
}
-(void)showShareTemplate:(NSDictionary*)dic{
    [MBProgressHUD hideHUDForView:self.webView];
    switch (self.tag) {
        case 1:
        {
            ShareMinProjModel * model = [ShareMinProjModel mj_objectWithKeyValues:dic];
            FHWeakSelf;
            [ShareChooseView shareChooseCallBack:^(NSInteger index) {
                
                if (index == 0) {
                    //分享小程序
                    [ShareMinProj share:model];
                }else
                {
                    //分享图片
                    [MBProgressHUD showMessage:@"" toView:weakSelf.webView];
                    weakSelf.tag = 2;
                    [weakSelf.webView evaluateJavaScript:@"getShareArguments(2)" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                        
                    }];
                }
                
            }];
            
        }
            break;
        case 2:
        {
            ShareImageModel * model = [ShareImageModel mj_objectWithKeyValues:dic];
            self.shareContentView.imageModel = model;
            [self.shareContentView show];
        
        }
            break;
        case 3:
        {
          
            ShareURLModel * model = [ShareURLModel mj_objectWithKeyValues:dic];
            self.shareURLView.urlModel = model;
            [self.shareURLView show];
        }
            break;
            
        default:
            break;
    }
}
-(ShareURLView *)shareURLView
{
    if (!_shareURLView) {
        _shareURLView = [[ShareURLView alloc]init];
    }
    return _shareURLView;
}
-(ShareContentView *)shareContentView
{
    if (!_shareContentView) {
        _shareContentView = [[ShareContentView alloc]init];
    }
    return _shareContentView;
    
}
@end
