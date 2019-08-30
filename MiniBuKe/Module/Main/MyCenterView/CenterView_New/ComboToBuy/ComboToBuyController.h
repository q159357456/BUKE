//
//  ComboToBuyController.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterBaseController.h"
#import "GoodsModel.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ComboToBuyController : CenterBaseController
@property(nonatomic,strong)GoodsModel *goodsModel;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)WKWebView *webview;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,assign)BOOL HaveBotom;
-(void)topay:(UIButton*)btn;
@end

NS_ASSUME_NONNULL_END
