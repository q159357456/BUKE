//
//  EditAdressController.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterBaseController.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface EditAdressController : CenterBaseController <WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler>
@property(nonatomic,strong)NSString *url;
@property(nonatomic, strong)WKWebView *webview;
@property(nonatomic,copy)void(^getAdessData)(void);
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

NS_ASSUME_NONNULL_END
