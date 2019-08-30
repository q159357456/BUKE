//
//  ShareMinProj.m
//  MiniBuKe
//
//  Created by chenheng on 2019/7/23.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "ShareMinProj.h"
#import <WXApi.h>
#import "CommonUsePackaging.h"
@implementation ShareMinProj
//分享小程序
+(void)share:(ShareMinProjModel*)model{
    
    if (!APP_DELEGATE.isWXInstalled)
    {
        [CommonUsePackaging showSystemHint:@"您还未安装微信客户端，请先下载安装"];
        return;
    }
    WXMiniProgramObject * obj = [WXMiniProgramObject object];
    obj.webpageUrl = model.webpageUrl;
    obj.userName = model.userName;
    NSLog(@"obj.path==>%@",obj.path);
    obj.path = model.path;
    obj.hdImageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.hdThumbImage]];
    obj.miniProgramType = model.type;
    
    WXMediaMessage * message = [WXMediaMessage message];
    message.title = model.title;
    message.description = model.mdescription;
    
    message.mediaObject = obj;
    message.thumbData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.thumbImage]];
    
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}
@end
