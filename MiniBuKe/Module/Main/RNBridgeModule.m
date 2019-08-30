//
//  RNBridgeModule.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/10.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "RNBridgeModule.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>

//解释：
//如果原生的方法要被JavaScript进行访问，那么该方法需要使用RCT_EXPORT_METHOD()宏定义进行声明。
//该声明的RNInvokeOCCallBack方法有两个参数:
//第一个参数代表从JavaScript传过来的数据,
//第二个参数是回调方法，通过该回调方法把原生信息发送到JavaScript中。

@interface RNBridgeModule ()

@end
@implementation RNBridgeModule

@synthesize bridge = _bridge;
RCT_EXPORT_MODULE(TTRNBridgeModule)

#pragma mark --RN调用OC方法，不需要传值和回调值
RCT_EXPORT_METHOD(rnCallNativeToMain){
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"I runCallNativeToMain function is oc");
    });
}

#pragma mark --RN调用OC方法，传值过来和不需要回调值
RCT_EXPORT_METHOD(rnCallNaticeToReaderBook:(NSDictionary *)dictionary){
    NSLog(@"%@",dictionary);
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}
#pragma mark --RN调用OC方法，传值过来和需要回调值
RCT_EXPORT_METHOD(rnInvokeisLoginCallBack:(NSDictionary *)dictionary callback:(RCTResponseSenderBlock)callback){
    NSDictionary *event =@{};
    callback(@[[NSNull null], event]);
}
#pragma mark ---下面的方法是OC调用RN中的方法，OC与RN的交互中，最麻烦的就是OC调用RN中的方法了，我尽量说得明白点吧，如果依然有不理解的，欢迎私信我！
#pragma mark ---开始订阅通知事件
RCT_EXPORT_METHOD(refreshViewNotification){
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshViewNotificationAction:) name:@"kNokNotificationNativeRefreshViewNotification" object:nil];
}
#pragma mark ---调用RN上面方法
-(void)refreshViewNotificationAction:(NSNotification *)not{
    [self.bridge.eventDispatcher sendAppEventWithName:@"refreshView" body:nil];
}
@end
