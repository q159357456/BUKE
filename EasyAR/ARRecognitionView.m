//
//  ARRecognitionView.m
//  MiniBuKe
//
//  Created by chenheng on 2019/4/25.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "ARRecognitionView.h"
#import <easyar/engine.oc.h>
#import <easyar/camera.oc.h>
#import <easyar/callbackscheduler.oc.h>
#import "AR_FAQ_View.h"
#import "ARAudioManager.h"
#import "ARReportUpLoadManager.h"
@interface ARRecognitionView()
@property(nonatomic,strong)NSMutableArray *ReadingAnimationPicList;
@property(nonatomic,strong)NSMutableArray *WaitingAnimationPicList;
@property(nonatomic,strong)NSMutableArray *ErroAnimamationPicList;
@property(nonatomic,strong)NSMutableArray *HitPagingAnimationPicList;
@property(nonatomic,strong)NSMutableArray *DownLoadingAnimationPicList;
@property(nonatomic,strong)NSMutableArray *DownSucessAnimationPicList;
@property(nonatomic,strong)NSMutableArray *DownFailedAnimationPicList;
@property(nonatomic,strong)UIImageView *headImageView;

@end
@implementation ARRecognitionView
{
    BOOL initialized;
}
static ARRecognitionView * _recognitionView = nil;
#pragma mark - public
+(instancetype)singleton{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _recognitionView = [[ARRecognitionView alloc]init];
    });
    return _recognitionView;
}
-(instancetype)init
{
    
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_STRING(@"#FFF7F0C8");
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_HEIGHT+20)];
        imageView.image = [UIImage imageNamed:@"easyar_bg"];
        self.bgView = imageView;
        [self addSubview:imageView];
        UIImageView *headImageView;
        if (kStatusBarH == 20) {
            headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCALE(404)-BOTTOM_HEIGHT+20, SCREEN_WIDTH, SCALE(404))];
        }else
        {
             headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCALE(410)-84-BOTTOM_HEIGHT, SCREEN_WIDTH, SCALE(410))];
             UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImageView.frame), SCREEN_WIDTH,  SCREEN_HEIGHT-BOTTOM_HEIGHT+20 - CGRectGetMaxY(headImageView.frame))];
             bottomView.backgroundColor = COLOR_STRING(@"#FFF9DD");
             [self addSubview:bottomView];
            
        }
        headImageView.image = [UIImage imageNamed:@"easyar_head"];
        [self addSubview:headImageView];
        self.headImageView = headImageView;
        
        UIImageView *defaultImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCALE(23), CGRectGetMinY(self.headImageView.frame)+ SCALE(130), SCALE(329), SCALE(207))];
        defaultImage.image = [UIImage imageNamed:@"easyrest"];
        [self addSubview:defaultImage];

        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-48, kStatusBarH==44?64:40 , 40, 40)];
//        btn.backgroundColor = [UIColor redColor];
        [btn setImage:[UIImage imageNamed:@"ar_problem_icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(faqFun:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, kStatusBarH+25, 50, 17)];
        label1.text = @"伴读";
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont boldSystemFontOfSize:SCALE(17)];
        label1.textColor = [UIColor whiteColor];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 45, CGRectGetMaxY(label1.frame) + 5, 90, 12)];
        label2.text = @"";
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = [UIFont systemFontOfSize:SCALE(15)];
        label2.textColor = A_COLOR_STRING(0xFFFFFF, 0.33);
        [self addSubview:label1];
        [self addSubview:label2];
        
        
    }
    return self;
}
-(void)faqFun:(UIButton*)btn{
    
    [AR_FAQ_View showFAQ];
 
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];

}
- (void)start
{
    [easyar_CameraDevice requestPermissions:[easyar_ImmediateCallbackScheduler getDefault] permissionCallback:^(easyar_PermissionStatus status, NSString *value) {
        switch (status) {
            case easyar_PermissionStatus_Denied:
                NSLog(@"camera permission denied");
                [self goToCamaraPremission];
                break;
            case easyar_PermissionStatus_Granted:
            {
                NSLog(@"permission allow");
                
                if (initialize()) {
                    start();
                }
                
            }
                break;
            case easyar_PermissionStatus_Error:
                NSLog(@"camera permission error");
                [self goToCamaraPremission];
                break;
            default:
                break;
        }
    }];
}

- (void)stop
{
    stop();
    finalize();
}
//读书动画
-(void)startReadingAnimation{
    
    if ( self.animationIndex != 1) {
        [self stopAndHiddenOtherAnimation];
        [self.readingImageView setHidden:NO];
        [self.readingImageView startAnimating];
        self.animationIndex = 1;
    }

}
//等待动画
-(void)startWaitingAnimation{
    
    if ( self.animationIndex != 2) {
        [self stopAndHiddenOtherAnimation];
        [self.waitingImageView setHidden:NO];
        [self.waitingImageView startAnimating];
        self.animationIndex = 2;
    }
    
    
    
}
//报错动画
-(void)startErroAnimamation{
    
     if ( self.animationIndex != 3) {
         [self stopAndHiddenOtherAnimation];
         [self.erroImageView setHidden:NO];
         [self.erroImageView startAnimating];
         self.animationIndex = 3;
     }
    
}

//提示翻页动画
-(void)startHintPagingAnimation{
    
    if ( self.animationIndex != 4) {
        [self stopAndHiddenOtherAnimation];
        [self.HitPagingImageView setHidden:NO];
        [self.HitPagingImageView startAnimating];
        self.animationIndex = 4;
    }
  
}

//下载动画
-(void)startDownLoadingAnimation{
    
    if ( self.animationIndex != 5) {
        [self stopAndHiddenOtherAnimation];
        [self.downLoadingImageView setHidden:NO];
        [self.downLoadingImageView startAnimating];
        self.animationIndex = 5;
    }
}
//下载成功动画
-(void)startDownLoadSuccessAnimation{
    
    if ( self.animationIndex != 6) {
        [self stopAndHiddenOtherAnimation];
        [self.downSucessImageView setHidden:NO];
        [self.downSucessImageView startAnimating];
        self.animationIndex = 6;
    }
}
//下载失败动画
-(void)startDownLoadFaildAnamation{
    
    if ( self.animationIndex != 7) {
        [self stopAndHiddenOtherAnimation];
        [self.downFailedImageView setHidden:NO];
        [self.downFailedImageView startAnimating];
        self.animationIndex = 7;
    }
}


//继续动画
-(void)startAnimation{
    
    if (self.animationIndex) {
        switch (self.animationIndex) {
            case 1:
            {
                [self.readingImageView startAnimating];
                [self.readingImageView setHidden:NO];
            }
                break;
            case 2:
            {
                [self.waitingImageView startAnimating];
                [self.waitingImageView setHidden:NO];
            }
                break;
                
            case 3:
            {
                [self.erroImageView startAnimating];
                [self.erroImageView setHidden:NO];
            }
                break;
            case 4:
            {
                [self.HitPagingImageView startAnimating];
                [self.HitPagingImageView  setHidden:NO];
            }
                break;
                
                
            default:
                break;
        }
    }
}
#pragma mark - pravite
-(void)stopAndHiddenOtherAnimation{
    NSLog(@"change动画,=%ld",self.animationIndex);
    if (self.animationIndex) {
        switch (self.animationIndex) {
            case 1:
            {
                [self.readingImageView stopAnimating];
                [self.readingImageView setHidden:YES];
            }
                break;
            case 2:
            {
                [self.waitingImageView stopAnimating];
                [self.waitingImageView setHidden:YES];
            }
                break;
                
            case 3:
            {
                [self.erroImageView stopAnimating];
                [self.erroImageView setHidden:YES];
            }
                break;
            case 4:
            {
                [self.HitPagingImageView stopAnimating];
                [self.HitPagingImageView  setHidden:YES];
            }
                break;
            case 5:
            {
                [self.downLoadingImageView stopAnimating];
                [self.downLoadingImageView  setHidden:YES];
            }
                break;
            case 6:
            {
                [self.downSucessImageView stopAnimating];
                [self.downSucessImageView  setHidden:YES];
            }
                break;
            case 7:
            {
                [self.downFailedImageView stopAnimating];
                [self.downFailedImageView  setHidden:YES];
            }
                break;
                
                
            default:
                break;
        }
    }
    
   
}
#pragma mark - lazy
-(NSMutableArray *)ReadingAnimationPicList
{
    if (!_ReadingAnimationPicList) {
        _ReadingAnimationPicList =[NSMutableArray array];
        for (NSInteger i=0; i<59; i++) {
            NSString *name = [NSString stringWithFormat:@"eye02_%02ld_",(long)i];
            UIImage *image = [UIImage imageNamed:name];
            
            [_ReadingAnimationPicList addObject:image];
        }
    }
    return _ReadingAnimationPicList;
}

-(NSMutableArray *)WaitingAnimationPicList
{
    if (!_WaitingAnimationPicList) {
        _WaitingAnimationPicList =[NSMutableArray array];
        for (NSInteger i=0; i<64; i++) {
            NSString *name = [NSString stringWithFormat:@"eye01_%02ld_",(long)i];
            UIImage *image = [UIImage imageNamed:name];
            [_WaitingAnimationPicList addObject:image];
            
        }
    }
    return _WaitingAnimationPicList;
}

-(NSMutableArray *)ErroAnimamationPicList
{
    if (!_ErroAnimamationPicList) {
        _ErroAnimamationPicList =[NSMutableArray array];
        for (NSInteger i=0; i<32; i++) {
            NSString *name = [NSString stringWithFormat:@"eye03_%02ld_",(long)i];
            UIImage *image = [UIImage imageNamed:name];
            [_ErroAnimamationPicList addObject:image];
            
        }
    }
    return _ErroAnimamationPicList;
}
-(NSMutableArray *)HitPagingAnimationPicList
{

    if (!_HitPagingAnimationPicList) {
        _HitPagingAnimationPicList =[NSMutableArray array];
        for (NSInteger i=0; i<64; i++) {
            NSString *name = [NSString stringWithFormat:@"eye04_%02ld_",(long)i];
            UIImage *image = [UIImage imageNamed:name];
            [_HitPagingAnimationPicList addObject:image];
            
        }
    }
    return _HitPagingAnimationPicList;
    
}
-(NSMutableArray *)DownLoadingAnimationPicList
{
    if (!_DownLoadingAnimationPicList) {
        
        _DownLoadingAnimationPicList  = [NSMutableArray array];
        for (NSInteger i=0; i<7; i++) {
            NSString *name = [NSString stringWithFormat:@"eye05_loding_%02ld_",(long)i];
            UIImage *image = [UIImage imageNamed:name];
            [_DownLoadingAnimationPicList addObject:image];
            
        }
        
    }
    return _DownLoadingAnimationPicList;
}
-(NSMutableArray *)DownSucessAnimationPicList
{
    if (!_DownSucessAnimationPicList) {
        _DownSucessAnimationPicList  = [NSMutableArray array];
        for (NSInteger i=0; i<4; i++) {
            NSString *name = [NSString stringWithFormat:@"eye06_download_yes_%02ld_",(long)i];
            UIImage *image = [UIImage imageNamed:name];
            [_DownSucessAnimationPicList addObject:image];
            
        }
    }
    return _DownSucessAnimationPicList;
}
-(NSMutableArray *)DownFailedAnimationPicList
{
    if (!_DownFailedAnimationPicList) {
        _DownFailedAnimationPicList = [NSMutableArray array];
        for (NSInteger i=0; i<19; i++) {
            NSString *name = [NSString stringWithFormat:@"eye07_download_no_%02ld_",(long)i];
            UIImage *image = [UIImage imageNamed:name];
            [_DownFailedAnimationPicList addObject:image];
            
        }
    }
    return _DownFailedAnimationPicList;
}

///
-(UIImageView *)readingImageView
{
    if (!_readingImageView) {
        _readingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCALE(23), CGRectGetMinY(self.headImageView.frame)+ SCALE(130), SCALE(329), SCALE(207))];
        _readingImageView.animationImages = self.ReadingAnimationPicList;
        _readingImageView.animationDuration = 6;
       _readingImageView.animationRepeatCount = MAXFLOAT;
        [self addSubview:_readingImageView];
    }
    return _readingImageView;
}
-(UIImageView *)waitingImageView
{
    if (!_waitingImageView) {
        _waitingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCALE(23), CGRectGetMinY(self.headImageView.frame)+ SCALE(130), SCALE(329), SCALE(207))];
        _waitingImageView.animationImages = self.WaitingAnimationPicList;
        _waitingImageView.animationDuration = 6;
        _waitingImageView.animationRepeatCount = MAXFLOAT;
        [self addSubview:_waitingImageView];
    }
    return _waitingImageView;
}
-(UIImageView *)erroImageView{
    
    if (!_erroImageView) {
       _erroImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCALE(23), CGRectGetMinY(self.headImageView.frame), SCALE(329), SCALE(337))];
        _erroImageView.animationImages = self.ErroAnimamationPicList;
        _erroImageView.animationDuration = 4;
        _erroImageView.animationRepeatCount = MAXFLOAT;
        [self addSubview:_erroImageView];
    }
    return _erroImageView;
}
-(UIImageView *)HitPagingImageView{
    
    if (!_HitPagingImageView) {
        _HitPagingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCALE(23), CGRectGetMinY(self.headImageView.frame)+ SCALE(130), SCALE(329), SCALE(207))];
        _HitPagingImageView.animationImages = self.HitPagingAnimationPicList;
        _HitPagingImageView.animationDuration = 6;
        _HitPagingImageView.animationRepeatCount = MAXFLOAT;
        [self addSubview:_HitPagingImageView];
    }
    return _HitPagingImageView;
}
-(UIImageView *)downFailedImageView
{
    if (!_downFailedImageView) {
        _downFailedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCALE(23), CGRectGetMinY(self.headImageView.frame)+ SCALE(130), SCALE(329), SCALE(271))];
        _downFailedImageView.animationImages = self.DownFailedAnimationPicList;
        _downFailedImageView.animationDuration = 2;
        _downFailedImageView.animationRepeatCount = MAXFLOAT;
        [self addSubview:_downFailedImageView];
    }
    return _downFailedImageView;
}
-(UIImageView *)downSucessImageView
{
    if (!_downSucessImageView) {
        _downSucessImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCALE(23), CGRectGetMinY(self.headImageView.frame)+ SCALE(130), SCALE(329), SCALE(207))];
        _downSucessImageView.animationImages = self.DownSucessAnimationPicList;
        _downSucessImageView.animationDuration = 1;
        _downSucessImageView.animationRepeatCount = 1;
        [self addSubview:_downSucessImageView];
    }
    return _downSucessImageView;
}

-(UIImageView *)downLoadingImageView
{
    if (!_downLoadingImageView) {
        _downLoadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCALE(23), CGRectGetMinY(self.headImageView.frame)+ SCALE(130), SCALE(329), SCALE(207))];
        _downLoadingImageView.animationImages = self.DownLoadingAnimationPicList;
        _downLoadingImageView.animationDuration = 2;
        _downLoadingImageView.animationRepeatCount = MAXFLOAT;
        [self addSubview:_downLoadingImageView];
    }
    return _downLoadingImageView;
}

//相机权限
-(void)goToCamaraPremission{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                    message:@"使用此功能要开启相机权限"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
      
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         NSURL *url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                         if (@available(iOS 10.0, *)) {
                                                             [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
                                                         } else {
                                                             // Fallback on earlier versions
                                                             NSURL *url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                             [[UIApplication sharedApplication]openURL:url];
                                                         }
                                                     }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [APP_DELEGATE.navigationController presentViewController:alert animated:YES completion:nil];
}
//
-(void)stopARAndAnimation{
    [ARManager onPause];
    [self stop];
    [self stopAndHiddenOtherAnimation];
    [[ARAudioManager singleton] stopPlay];
    [ARAudioManager singleton].InEasyAR_Working = NO;
    [self removeFromSuperview];
}


@end
