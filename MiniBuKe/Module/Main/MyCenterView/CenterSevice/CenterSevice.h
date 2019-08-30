//
//  CenterSevice.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CompletionHandler)(id responsed,NSError *error);
NS_ASSUME_NONNULL_BEGIN

@interface CenterSevice : NSObject
//获取优惠券信息(GET)
+(void)pay_goods:(NSString*)goodsid AndFinish:(CompletionHandler)completionHandler;
//预支付订单(POST)
+(void)pay_wx_order:(NSString*)goodsId UserDisId:(NSString*)userDisId AndFinish:(CompletionHandler)completionHandler;
//获取默认收货地址(GET)
+(void)pay_address:(CompletionHandler)completionHandler;
//分享生成图片
+(void)user_invitation_share:(CompletionHandler)completionHandler;
//分享URL(/v1/invitation/share/{sort})
+(void)v1_invitation_share:(NSInteger)sort CompletionHandler:(CompletionHandler)completionHandler;
//加或者修改用户收货地址
+(void)post_pay_addressAdressData:(NSDictionary*)params CompletionHandler:(CompletionHandler)completionHandler;
//拉取宝贝信息(GET )
+(void)user_fetchBabyInfo:(CompletionHandler)completionHandler;
//上传宝贝头像获得(POST)
+(void)user_uploadBabyAvatar:(NSArray*)data CompletionHandler:(CompletionHandler)completionHandler;
//更新宝贝信息(POST)
+(void)user_updateBabyInfo:(NSDictionary*)params CompletionHandler:(CompletionHandler)completionHandler;
//上传宝贝信息(POST)
+(void)user_uploadBabyInfo:(NSDictionary*)params CompletionHandler:(CompletionHandler)completionHandler;
//app获取标签分类GET /pub/tag/list/{type}
+(void)pub_tag_list_type:(NSString*)type CompletionHandler:(CompletionHandler)completionHandler;
//机器人电池量(GET)
+(void)pub_robot_battery:(CompletionHandler)completionHandler;
//机器人是否联网(GET)
+(void)robot_isOnline:(CompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
