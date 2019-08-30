//
//  ShareURLView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ShareURLView.h"
#import "BKMyBtton.h"
#import <ShareSDK/ShareSDK.h>
#import "CommonUsePackaging.h"
#define ShareViewHeight SCALE(141)
@interface ShareURLView ()
@property(nonatomic,strong)UIView *shareView;
@end
@implementation ShareURLView

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = A_COLOR_STRING(0x2F2F2F, 0.7);
        [self addSubview:self.shareView];
        
        
    }
    return self;
}
-(UIView *)shareView
{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,ShareViewHeight)];
        _shareView.backgroundColor = COLOR_STRING(@"#F8F8F8");
        NSArray *titleArray = @[@"微信朋友圈",@"微信"];
        NSArray *imageArray = @[@"wechat_friends_icon",@"wechat_icon_c"];
        CGFloat width = SCREEN_WIDTH/2;
        BKMyBtton *btn1 = [[BKMyBtton alloc]initWithFrame:CGRectMake(0, 0, width, ShareViewHeight) ImageFrame:CGRectMake(SCALE(85), SCALE(30), SCALE(60), SCALE(60)) TitleFrame:CGRectMake(SCALE(83), SCALE(99), SCALE(64), 13)];
        
        btn1.titleImage.image = [UIImage imageNamed:imageArray[0]];
        btn1.contentText.text = titleArray[0];
        btn1.contentText.font = [UIFont systemFontOfSize:SCALE(12)];
        [btn1 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag = 1;
        [_shareView addSubview:btn1];
        
        BKMyBtton *btn2 = [[BKMyBtton alloc]initWithFrame:CGRectMake(width, 0, width, ShareViewHeight) ImageFrame:CGRectMake(width- SCALE(85)-SCALE(60), SCALE(30), SCALE(60), SCALE(60)) TitleFrame:CGRectMake(width-SCALE(83)-SCALE(64), SCALE(99), SCALE(64), 13)];
        btn2.titleImage.image = [UIImage imageNamed:imageArray[1]];
        btn2.contentText.text = titleArray[1];
        btn2.contentText.font = [UIFont systemFontOfSize:SCALE(12)];
        [btn2 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        btn2.tag = 2;
        [_shareView addSubview:btn2];
    }


           
    return _shareView;
}
-(void)onClick:(UIButton*)btn{
 
    [self hidden];
    if (!APP_DELEGATE.isWXInstalled)
    {
        [CommonUsePackaging showSystemHint:@"您还未安装微信客户端，请先下载安装"];
        return;
    }
    if (btn.tag == 1) {
        [[BaiduMobStat defaultStat] logEvent:@"e_share150" eventLabel:@"微信朋友圈" attributes:@{@"template":self.model.templateType, @"shareUrl":[NSString stringWithFormat:@"type=%@ & id=%@",self.model.templateType,self.model.templateID]}];
        
        if (self.urlModel) {
            [self new_Share:SSDKPlatformSubTypeWechatTimeline];
        }else
        {
             [self share:SSDKPlatformSubTypeWechatTimeline];
        }
       
    }else
    {
        [[BaiduMobStat defaultStat] logEvent:@"e_share150" eventLabel:@"微信好友" attributes:@{@"template":self.model.templateType, @"shareUrl":[NSString stringWithFormat:@"type=%@ & id=%@",self.model.templateType,self.model.templateID]}];

          if (self.urlModel) {
                [self new_Share:SSDKPlatformSubTypeWechatSession];
          }else
          {
                [self share:SSDKPlatformSubTypeWechatSession];
          }
      
    }
    
    
}
-(void)share:(SSDKPlatformType)PlatformType{
    NSURL *url = [NSURL URLWithString:self.model.shareUrl.length?self.model.shareUrl:@""];
    NSString *describ = [NSString stringWithFormat:@"%@\n       ——%@",self.model.saying,self.model.auth];
    NSString *imageString = self.model.shareImage;
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (imageString.length>0) {
           [shareParams SSDKSetupWeChatParamsByText:describ title:self.model.title url:url thumbImage:imageString image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeWebPage forPlatformSubType:PlatformType];
    }else
    {
          [shareParams SSDKSetupWeChatParamsByText:describ title:self.model.title url:url thumbImage:nil image:[UIImage imageNamed:@"login_toplogon_icon"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeWebPage forPlatformSubType:PlatformType];
    }

    
    [ShareSDK share:PlatformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSLog(@"成功");
                
                break;
            }
            case SSDKResponseStateFail:
            {
                NSLog(@"error:%@",error);
                
                break;
            }
            default:
                break;
        }
        
    }];
}


-(void)show
{
    [APP_DELEGATE.window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT-ShareViewHeight, SCREEN_WIDTH , ShareViewHeight);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ShareViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hidden];
}
-(void)new_Share:(SSDKPlatformType)PlatformType{
    
    NSURL *url = [NSURL URLWithString:self.urlModel.url];
    NSString *describ = self.urlModel.mdescription;
    NSString *imageString = self.urlModel.thumbImage;
    NSString * title = self.urlModel.title;
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (imageString.length>0) {
        [shareParams SSDKSetupWeChatParamsByText:describ title:title url:url thumbImage:imageString image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeWebPage forPlatformSubType:PlatformType];
    }else
    {
        [shareParams SSDKSetupWeChatParamsByText:describ title:title url:url thumbImage:nil image:imageString musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeWebPage forPlatformSubType:PlatformType];
    }
    
    
    [ShareSDK share:PlatformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSLog(@"成功");
                
                break;
            }
            case SSDKResponseStateFail:
            {
                NSLog(@"error:%@",error);
                
                break;
            }
            default:
                break;
        }
        
    }];
}
@end
