//
//  BookneededScanningCodeVC.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookneededScanningCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanningCodeView.h"
#import "SwichCodePhotoView.h"
#import "UIResponder+Event.h"
#import "PhotoShowView.h"
#import "ScanningService.h"
#import "IntensiveReadingController.h"
#import "ScoreRemindView.h"
#import "BKWKWebViewController.h"
#import "BKPhotoImageSelectCtr.h"
#import "XBKNetWorkManager.h"
#import "BKUploadingTipCtr.h"
#import "AFNetworkReachabilityManager.h"
#import "BKMemberWebController.h"
@interface BookneededScanningCodeVC ()<AVCaptureMetadataOutputObjectsDelegate>
/** CODE会话对象 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 图层类 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
/** 照相会话对象 */
@property (nonatomic, strong) AVCaptureSession *p_session;
/** 照相图层类 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *p_previewLayer;
/** 扫描界面 */
@property(nonatomic,strong)ScanningCodeView * scanningCodeView;
/** 切换模式 */
@property(nonatomic,strong)SwichCodePhotoView * swichCodePhotoView;
/** 扫码输出流 */
@property(nonatomic,strong) AVCaptureMetadataOutput *codeOutput;
/** 相机输出流 */
@property(nonatomic,strong)AVCaptureStillImageOutput * photographOutput ;
/** 扫码输入流 */
@property(nonatomic,strong)AVCaptureDeviceInput *input;
/** 相机输入流 */
@property(nonatomic,strong)AVCaptureDeviceInput *p_input;

/** 展示相机照片 */
@property(nonatomic,strong)PhotoShowView *photoShowView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *PhotoLibBtn;
@property(nonatomic,strong)UIButton *LightbBtn;
/**拍照的到的image*/
@property(nonatomic,strong)UIImage *uploadImage;



@end

@implementation BookneededScanningCodeVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 9、启动会话
    if (self.session_Style == Code_Session)
    {
        [self.session startRunning];
    }else
    {
        [self.p_session startRunning];
    }

    
 
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.session stopRunning];
    [self.p_session stopRunning];
    [self.timer invalidate];
    self.LightbBtn.selected = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"扫一扫";
    [self.view addSubview:self.topView];
    [self.view addSubview:self.swichCodePhotoView];
    [self.view bringSubviewToFront:self.swichCodePhotoView];
    [self.view addSubview:self.scanningCodeView];
    [self.view sendSubviewToBack:self.scanningCodeView];
    [self addObserverAFNListen];
    // Do any additional setup after loading the view.
}
#pragma remind
-(void)remind{
    
    self.scanningCodeView.promptLabel.text = @"请对准条形码/二维码,耐心等待";
    [self.timer invalidate];
}
#pragma mark - 监听网络状态
-(void)addObserverAFNListen{
    
    //创建网络监听对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //开始监听
    [manager startMonitoring];
    //监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请检查网络设置"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请检查网络设置"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
               
                break;
        }
    }];
    //结束监听
    [manager stopMonitoring];
    
}
#pragma mark - 懒加载

-(UIView *)topView
{
    if (!_topView) {
        CGFloat statuHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat navHeight = 44.f + statuHeight;
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, navHeight)];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_topView.bounds.size.width/2 - 100,statuHeight==44?35:30, 200, 20)];
        _topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_topView addSubview:self.titleLabel];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, statuHeight==44?25:18 , 40, 40)];
        [backButton setImage:[UIImage imageNamed:@"therefore_navibar_back "] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:backButton];
        UIButton *rightBtn= [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 55, statuHeight==44?25:18, 40, 40)];
        [rightBtn setImage:[UIImage imageNamed:@"flashlight"] forState:UIControlStateNormal];//flashlight_bright
        [rightBtn setImage:[UIImage imageNamed:@"flashlight_bright"] forState:UIControlStateSelected];
        [_topView addSubview:rightBtn];
        self.LightbBtn = rightBtn;
        
        self.PhotoLibBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, statuHeight==44?25:18 , 40, 40)];
        [self.PhotoLibBtn setImage:[UIImage imageNamed:@"album"] forState:UIControlStateNormal];
        self.PhotoLibBtn.hidden =YES;
        [_topView addSubview:self.PhotoLibBtn];
        [_PhotoLibBtn addTarget:self action:@selector(choosePhotos:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(light_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _topView;
}

-(ScanningCodeView *)scanningCodeView
{
    if (!_scanningCodeView) {
        
        _scanningCodeView = [ScanningCodeView scanningQRCodeViewWithFrame:self.view.bounds outsideViewLayer:self.view];
    }
    return _scanningCodeView;
}
-(AVCaptureSession *)session
{
    if (!_session) {
        // 5、 初始化链接对象（会话对象）
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    return _session;
}
-(AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewLayer) {
        // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = self.view.layer.bounds;
        
    }
    return _previewLayer;
}
-(AVCaptureSession *)p_session
{
    if (!_p_session) {
        _p_session = [[AVCaptureSession alloc]init];
    }
    return _p_session;
}

-(AVCaptureVideoPreviewLayer *)p_previewLayer
{
    if (!_p_previewLayer) {
        _p_previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.p_session];
        _p_previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _p_previewLayer.frame = self.view.layer.bounds;
    }
    return _p_previewLayer;
}
-(SwichCodePhotoView *)swichCodePhotoView
{
    if (!_swichCodePhotoView) {
        
        _swichCodePhotoView = [[SwichCodePhotoView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 84, SCREEN_WIDTH, 84)];
        
    }
    return _swichCodePhotoView;
}


-(AVCaptureMetadataOutput *)codeOutput
{
    if (!_codeOutput) {
        _codeOutput = [[AVCaptureMetadataOutput alloc] init];
        
        [_codeOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        
        // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
        // 注：微信二维码的扫描范围是整个屏幕， 这里并没有做处理（可不用设置）
        //           output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
        // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
        // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
     
    }
    return _codeOutput;
}
-(AVCaptureStillImageOutput *)photographOutput
{
    if (!_photographOutput) {
        _photographOutput = [[AVCaptureStillImageOutput alloc]init];
        // 输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,@(0.1),AVVideoQualityKey,nil];
        [_photographOutput setOutputSettings:outputSettings];
    }
    return _photographOutput;
}

-(AVCaptureDeviceInput *)input
{
    if (!_input) {
        // 1、获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    }
    return _input;
}

-(AVCaptureDeviceInput *)p_input
{
    if (!_p_input) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _p_input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    }
    return _p_input;
}
-(PhotoShowView *)photoShowView
{
    if (!_photoShowView) {
      
        _photoShowView = [[PhotoShowView alloc]initWithFrame:self.view.bounds];
        _photoShowView.backgroundColor = [UIColor whiteColor];
    }
    return _photoShowView;
}

#pragma mark - 相机权限判断
-(BOOL)jugeAuthStatu{
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        NSString *errorStr = @"应用相机权限受限,请在设置中启用";
        //直接跳转到 【设置-隐私-照片】
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                        message:errorStr
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
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
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
        
    }else
    {
        
        return YES;
    }
    
}

#pragma mark - 扫描
- (void)setupScanningQRCode {
    
    if ([self jugeAuthStatu]) {


        [self.session beginConfiguration];
        // 5.1 添加会话输入
        if ([self.session canAddInput:self.input]) {
            
            [self.session addInput:self.input];
        }
        
        // 5.2 添加会话输出
        if ([self.session canAddOutput:self.codeOutput]) {
            
             [self.session addOutput:self.codeOutput];
            self.codeOutput.metadataObjectTypes = @[ AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode];
            
        }
       
         [self.session commitConfiguration];
        
       
    }
    

}

#pragma mark - action 切换到拍照模式
-(void)switchToPhonetoStyle{

    if ([self jugeAuthStatu]) {
    

        [self.p_session beginConfiguration];
        if ([self.p_session canAddInput:self.p_input]) {
            
            [self.p_session addInput:self.p_input];
            
        }
        
        if ([self.p_session canAddOutput:self.photographOutput]) {
            
            [self.p_session addOutput:self.photographOutput];
            
        }
        
        [self.p_session commitConfiguration];
    }
   

}

-(void)backButtonClick{
    
    [APP_DELEGATE.navigationController popViewControllerAnimated:YES];
}
#pragma mark - - - 照明灯的点击事件
- (void)light_buttonAction:(UIButton *)button {
    
    button.selected = !button.selected;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
       
        if (button.selected) {
             [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOn];
             [device unlockForConfiguration];
        } else {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
       
    }
}
-(void)choosePhotos:(UIButton*)btn{
    
    BKPhotoImageSelectCtr *ctr = [[BKPhotoImageSelectCtr alloc]init];
    ctr.selectPhotoOfMax = 9;
    [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
}


#pragma mark - uiresponder
-(void)eventName:(NSString *)eventname Params:(id)params
{
    if ([eventname isEqualToString:SwichCodePhotoView_Event])
    {
        
        NSInteger index = [params integerValue];
        if (index == 1)
        {
            NSLog(@".....扫描");
            //计时
            self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(remind) userInfo:nil repeats:NO];
            // 8、将图层插入当前视图
            [self.p_previewLayer removeFromSuperlayer];
            [self.view.layer insertSublayer:self.previewLayer atIndex:0];
            [self.session startRunning];
            [self.p_session stopRunning];
            self.session_Style = Code_Session;
            self.PhotoLibBtn.hidden =YES;
            self.titleLabel.text = @"扫描条形码/二维码";
            [self setupScanningQRCode];
            self.scanningCodeView.funcMode = ScanCodeMode;
            
        }else
        {
            
            
            [self.timer invalidate];
            [self.previewLayer removeFromSuperlayer];
            [self.view.layer insertSublayer:self.p_previewLayer atIndex:0];
            [self.p_session startRunning];
            [self.session stopRunning];
            self.session_Style = PhotoGraph_Session;
            self.PhotoLibBtn.hidden =NO;
            self.titleLabel.text = @"拍照";
            [self switchToPhonetoStyle];
            self.scanningCodeView.funcMode = Photograph;
        }
    }
    
    else if ([eventname isEqualToString:ScanningCodeView_Event])
    {
        
        if ([params isEqualToString:photoGraphEvent])
        {
            
            [self actionStartCamera];
        }
        
        
    }
    
    else if ([eventname isEqualToString:PhotoShowView_Event])
    {
        NSInteger index = [params integerValue];
        if (index == 1)
        {
            //取消
            NSLog(@"取消");
            [self.photoShowView removeFromSuperview];
            self.uploadImage = nil;
            
        }else
        {
            //上传
            NSLog(@"上传照片");
            NSArray *array = [NSArray arrayWithObject:self.uploadImage];
            [self uploadWithImageArray:array];
        }
        
    }
}

#pragma mark - 照相
-(void)actionStartCamera
{
    
    AVCaptureConnection *videoConnection = [self.photographOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (!videoConnection)
    {
        return;
    }
    
    [self.photographOutput  captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer == NULL) {
            
            return;
            
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *originalImage = [UIImage imageWithData:imageData];

            [self.view addSubview:self.photoShowView];
            self.photoShowView.ShowPhotoImageView.image = originalImage;
            self.uploadImage = originalImage;
        //1.旋转照片
//        UIImage *rotateImage = [originalImage rotate:UIImageOrientationRight];

    }];
}



#pragma mark - AVCaptureMetadataOutputObjectsDelegate ( 会频繁的扫描，调用代理方法)
-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    // 2. 删除预览图层
    // 3. 设置界面显示扫描结果
    if (metadataObjects.count > 0)
    {
        [self.timer invalidate];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
//        NSLog(@"url=====>%@",obj.stringValue);
//        if ([obj.stringValue hasPrefix:@"http"]||[obj.stringValue hasPrefix:@"https"])
//        {
//              [self.session startRunning];
//
//        }else
//        {
            // 9787513525596 9787544258975
            NSArray *array = [[obj.stringValue copy] componentsSeparatedByString:@";"];
            NSString *value = nil;
            if (array.count == 2)
            {
                //二维码
                NSString *type = array[0];
                value = array[1];
                if (type.integerValue == 2) {
                    //激活码
                    NSLog(@"value==>%@",value);
                    [MBProgressHUD showMessage:@"识别中..."];
                    FHWeakSelf;
                    [XBKNetWorkManager memberActivateMemberWithActivationCode:value Finish:^(MemberModel * _Nonnull model, NSError * _Nonnull error) {
                        
                        [MBProgressHUD hideHUD];
                        if (model.code == 1) {
                            [[[BKLoginCodeTip alloc]init] ActivicodeSuccess:APP_DELEGATE.window];
                        }else
                        {
                            [[[BKLoginCodeTip alloc]init] codeInvalidTip:APP_DELEGATE.window Info:model.msg];
                        }
                        
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        
                    }];
                    return;
                }
                
                if (type.integerValue == 3) {
                    
                    BKMemberWebController * vc = [[BKMemberWebController alloc]init];
                    vc.url = [NSString stringWithFormat:@"%@/template/html/vipPage2/vipPage2.html?token=%@&libId=%@",H5SERVER_URL,TokenEncode,value];
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                
                
            }else
            {
                //条形码
                value = obj.stringValue;
            }
            
            if (![value hasPrefix:@"978"] || value.length != 13) {
                ScoreRemindView *reminde =[[ScoreRemindView alloc]initWithFrame:[UIScreen mainScreen].bounds Title:@"这不是一本书" Info:@"当前无结果,可以拍照上传你想读的绘本" ImageName:@"scanning_image" Block:^{
                    [self.session startRunning];
                    NSLog(@"知道了");
                }];
                [APP_DELEGATE.window addSubview:reminde];
                return;
            }
            
            [self handleISBN:value];
            
//        }
    }else
    {
        [MBProgressHUD showError:@"不能识别"];
    }
}

#pragma mark - 如果是isbn 并且有资源跳转到绘本详情,否则跳转缺书登记
-(void)handleISBN:(NSString*)isbn{
    
    [MBProgressHUD showMessage:@""];
    [ScanningService BookRegister:isbn :^(BookStatusModle * _Nonnull model, NSError * _Nonnull error) {
        
        if (error == nil) {
            [MBProgressHUD hideHUD];
            if (!model.status) {
                
                ScoreRemindView *reminde =[[ScoreRemindView alloc]initWithFrame:[UIScreen mainScreen].bounds Title:@"小布壳正在学会识别这本书哦" Info:@"当前无结果,可以拍照上传你想读的绘本" ImageName:@"scanning_image" Block:^{
                    [self.session startRunning];
                    NSLog(@"知道了");
                }];
                [APP_DELEGATE.window addSubview:reminde];
                
            }else if (model.status == 1)
            {
                
                if (model.bookId) {
                    
                    IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
                    vc.bookid = [NSString stringWithFormat:@"%ld",(long)model.bookId];
                    vc.isScanningTo = YES;
                    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
                }
                
            }else
            {
                if (model.url.length>1) {
                    
                    BKWKWebViewController *vc = [[BKWKWebViewController alloc]init];
                    vc.url = model.url;
                    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
                }
            }
            
        }else
        {
            [MBProgressHUD hideHUD];
            if (error.code == -1001) {
                [MBProgressHUD showError:@"请求超时"];
                return ;
            }else
            {
                [MBProgressHUD showError:@"网络错误"];
            }
            
            [self.session startRunning];
            
        }
        
    }];
}
#pragma mark - 确认上传
- (void)showBusyTip{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view ];
    //修改样式，否则等待框背景色将为半透明
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //设置等待框背景色为黑色
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.removeFromSuperViewOnHide = YES;
    //设置菊花框为白色
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    [self.view addSubview:hud];
    [hud showAnimated:YES];
}
- (void)uploadWithImageArray:(NSArray*)imageArray{
    [self showBusyTip];
    [XBKNetWorkManager requestBookRegisterPictureWithImageArray:imageArray AndAndFinish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];
        if (error == nil) {
            if ([[responseObj objectForKey:@"success"]integerValue] && [[responseObj objectForKey:@"state"]integerValue]==1) {
                NSLog(@"上传成功了");
                [self uploadingSuccess];
            }else{
                NSLog(@"上传失败了");
                [self uploadingFail];
            }
        }else{
            NSLog(@"上传失败了");
            [self uploadingFail];
        }
    }];
}

-(void)uploadingSuccess{
    BKUploadingTipCtr *ctr = [[BKUploadingTipCtr alloc]initWithTitle:@"上传成功" andDes:@"小布会尽快上架" andleftBtnTitle:@"返回首页" andrightBtnTitle:@"继续拍照" andIconName:@"uploadsuccesstip"];
    ctr.view.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
    ctr.modalPresentationStyle = UIModalPresentationOverFullScreen;

    [ctr setUploadTipLeftBtnClick:^{
        [self.photoShowView removeFromSuperview];
        self.uploadImage = nil;
        [APP_DELEGATE.navigationController popViewControllerAnimated:YES];
    }];
    [ctr setUploadTipRightBtnClick:^{
        [self.photoShowView removeFromSuperview];
        self.uploadImage = nil;
    }];
    [self presentViewController:ctr animated:NO completion:^{
        
    }];
}
-(void)uploadingFail{
    BKUploadingTipCtr *ctr = [[BKUploadingTipCtr alloc]initWithTitle:@"上传失败" andDes:@"建议检查你的网络是否顺畅" andleftBtnTitle:@"返回首页" andrightBtnTitle:@"重新上传" andIconName:@"uploadsuccesstip"];
    ctr.view.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
    ctr.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [ctr setUploadTipLeftBtnClick:^{
        [self.photoShowView removeFromSuperview];
        self.uploadImage = nil;
        [APP_DELEGATE.navigationController popViewControllerAnimated:YES];
    }];
    [ctr setUploadTipRightBtnClick:^{
        
    }];
    [self presentViewController:ctr animated:NO completion:^{
        
    }];
}
@end
