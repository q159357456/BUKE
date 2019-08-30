//
//  ShareContentView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ShareContentView.h"
#import <ShareSDK/ShareSDK.h>
#import "BKMyBtton.h"
#import "BKLoginCodeTip.h"
#import <Photos/Photos.h>
#import "CommonUsePackaging.h"

@interface ShareContentView()
@property(nonatomic,strong)UIView *topBackGView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIView *backGView;
@property(nonatomic,strong)UIScrollView *scroView;
@property(nonatomic,strong)UIImage *shareImage;
@end
@implementation ShareContentView

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = A_COLOR_STRING(0x2F2F2F, 0.7);
        self.backGView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self addSubview:self.backGView];
        [self.backGView addSubview:self.topBackGView];
        [self.backGView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.backGView.mas_bottom);
            make.left.mas_equalTo(self.backGView.mas_left);
            make.right.mas_equalTo(self.backGView.mas_right);
            make.height.mas_equalTo(141+45);
        }];
        [self.topBackGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-18);
            make.centerX.mas_equalTo(self.backGView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(SCALE(328), SCALE(440)));
            
            
        }];
 
    }
    return self;
}
-(UIScrollView *)scroView
{
    if (!_scroView) {
        _scroView = [[UIScrollView alloc]init];
        _scroView.showsVerticalScrollIndicator = NO;
        _scroView.showsHorizontalScrollIndicator = NO;
        _scroView.bounces = NO;
    }
    return _scroView;
}
-(void)show
{
    [APP_DELEGATE.window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backGView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(UIView *)backGView
{
    if (!_backGView) {
        _backGView = [[UIView alloc]init];
        _backGView.backgroundColor = [UIColor clearColor];
        
    }
    return _backGView;
}
-(UIView *)topBackGView
{
    if (!_topBackGView) {
        
        _topBackGView = [[UIView alloc]init];
        _topBackGView.backgroundColor = [UIColor whiteColor];
        _topBackGView.layer.cornerRadius = 8;
        _topBackGView.layer.masksToBounds = YES;
        [_topBackGView addSubview:self.scroView];
        [self.scroView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0  ));
        }];

        
    }
    return _topBackGView;
    
}
-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = COLOR_STRING(@"#F8F8F8");
        NSArray *titleArray = @[@"微信",@"微信朋友圈",@"保存图片"];
        NSArray *imageArray = @[@"wechat_icon_c",@"wechat_friends_icon",@"save_image_icon"];
        for (NSInteger i=0; i<3; i++) {
            CGFloat width = SCREEN_WIDTH/3;
            BKMyBtton *btn = [[BKMyBtton alloc]initWithFrame:CGRectMake(i*width, 0, width, 141) ImageFrame:CGRectMake(width/2 - 30, 29, 60, 60) TitleFrame:CGRectMake(0, 99, width, 13)];
            btn.titleImage.image = [UIImage imageNamed:imageArray[i]];
            btn.contentText.text = titleArray[i];
            btn.contentText.font = [UIFont systemFontOfSize:13];
            [_bottomView addSubview:btn];
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i + 100;
        }
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 141, SCREEN_WIDTH, 45)];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
    }
    
    return _bottomView;
}
-(void)setImageurl:(NSString *)imageurl
{
    _imageurl = imageurl;
    if (imageurl.length>4) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [MBProgressHUD showMessage:@"" toView:self];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageurl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [MBProgressHUD hideHUDForView:self];
            self.shareImage  = image;
            CGSize size = image.size;
            CGFloat w = size.width;
            CGFloat H = size.height;
            CGFloat scale = H/w;
            CGFloat suW = SCALE(328);
            if (isnan(scale)) {
                scale = self.topBackGView.bounds.size.height/self.topBackGView.bounds.size.width;
            }
            imageView.frame = CGRectMake(0, 0,suW, suW * scale);
            self.scroView.contentSize = CGSizeMake(suW, suW*scale);
            [self.scroView addSubview:imageView];
            
        }];
    }
}
-(void)setImageModel:(ShareImageModel *)imageModel
{
    _imageModel = imageModel;
    if (_imageModel.image.length) {
        if ([_imageModel.image hasPrefix:@"http"] || [_imageModel.image hasPrefix:@"https"]) {
            UIImageView *imageView = [[UIImageView alloc]init];
            [MBProgressHUD showMessage:@"" toView:self];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imageModel.image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [MBProgressHUD hideHUDForView:self];
                self.shareImage  = image;
                CGSize size = image.size;
                CGFloat w = size.width;
                CGFloat H = size.height;
                CGFloat scale = isnan(H/w)?1:H/w;
                CGFloat suW = SCALE(328);
                if (isnan(scale)) {
                    scale = self.topBackGView.bounds.size.height/self.topBackGView.bounds.size.width;
                }
                imageView.frame = CGRectMake(0, 0,suW, suW * scale);
                self.scroView.contentSize = CGSizeMake(suW, suW*scale);
                [self.scroView addSubview:imageView];
                
            }];
        }else
        {
            UIImageView *imageView = [[UIImageView alloc]init];
            [MBProgressHUD showMessage:@"" toView:self];
            NSLog(@"message.name==>%@",imageModel.image);
            NSString * base64 = [_imageModel.image stringByReplacingOccurrencesOfString:@"data:image/png;base64," withString:@""];
            NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage * image = [UIImage imageWithData:data];
            imageView.image = image;
            [MBProgressHUD hideHUDForView:self];
            self.shareImage  = image;
            CGSize size = image.size;
            CGFloat w = size.width;
            CGFloat H = size.height;
            CGFloat scale = isnan(H/w)?1:H/w;
            CGFloat suW = SCALE(328);
            if (isnan(scale)) {
                scale = self.topBackGView.bounds.size.height/self.topBackGView.bounds.size.width;
            }
            imageView.frame = CGRectMake(0, 0,suW, suW * scale);
            self.scroView.contentSize = CGSizeMake(suW, suW*scale);
            [self.scroView addSubview:imageView];
        }
    

    }
    
}
-(void)close:(UIButton*)btn{
    
    [self hidden];
}

-(void)onClick:(UIButton*)btn{
    
   
    NSInteger index = btn.tag - 100;
    switch (index) {
        case 1:
        {
            if (!APP_DELEGATE.isWXInstalled)
            {
                [CommonUsePackaging showSystemHint:@"您还未安装微信客户端，请先下载安装"];
                return;
            }
//            [MobClick event:EVENT_Custom_111 ];
            [self share:SSDKPlatformSubTypeWechatTimeline];

            
        }
            break;
        case 0:
        {

            if (!APP_DELEGATE.isWXInstalled)
            {
                [CommonUsePackaging showSystemHint:@"您还未安装微信客户端，请先下载安装"];
                return;
            }
//            [MobClick event:EVENT_Custom_112];
            [self share:SSDKPlatformSubTypeWechatSession];
        }
            break;
        case 2:
        {
     
            //保存图片到【相机胶卷】
            // 异步执行修改操作
//            [MobClick event:EVENT_Custom_113];
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
            {
                 [CommonUsePackaging showSystemHint:@"您还未开启相册权限,请到设置中开启权限"];
                
            }else
            {
                [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
                    [PHAssetChangeRequest creationRequestForAssetFromImage:self.shareImage];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    if (error) {
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showSuccess:@"保存成功"];
                        });
                    }
                }];
                
            }
           
        }
            break;
            
        default:
            break;
    }
     [self hidden];
}

-(void)share:(SSDKPlatformType)PlatformType{
    if (!self.shareImage) {
        
        return;
    }
    //1、创建分享参数
    NSArray* imageArray = @[self.shareImage];
    if (imageArray) {
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupAliSocialParamsByText:@"buke" image:imageArray title:self.imageModel.title url:nil type:SSDKContentTypeImage platformType:PlatformType];
       
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
    
}
@end
