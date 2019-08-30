//
//  BKBookneededUploadCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBookneededUploadCtr.h"
#import "XBKNetWorkManager.h"
#import "BKUploadingTipCtr.h"

#define leftRightoff  15.f
#define btnOff 10.f
#define btnW ((SCREEN_WIDTH-2*leftRightoff-2*btnOff)/3.f)

@interface BKBookneededUploadCtr ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) NSMutableArray *imageArray;
//@property(nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation BKBookneededUploadCtr
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
}

- (void)hideBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)showBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_STRING(@"#F7F9FB");
    [self initTopView];

}

- (void)addDataWithArray:(NSMutableArray*)array{
    if (self.imageArray == nil) {
        self.imageArray = [NSMutableArray array];
    }
    [self.imageArray addObjectsFromArray:array];
    if (self.imageArray.count) {
        for (int i = 0; i<self.imageArray.count; i++) {
            NSInteger index = i;
            UIImageView *btn = [[UIImageView alloc]initWithFrame:CGRectMake(leftRightoff+(index%3)*(btnW+btnOff), 30+kNavbarH+(index/3)*(btnW+btnOff),btnW, btnW)];
            btn.tag = index;
            btn.image = array[i];
            btn.contentMode = UIViewContentModeScaleToFill;
            btn.clipsToBounds = YES;
            [self.view addSubview:btn];
        }
    }
}


- (void)initTopView{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,kNavbarH)];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,kStatusBarH,self.view.frame.size.width,44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"上传照片";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2F2F2F");
    [_topView addSubview: titleLabel];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, kStatusBarH, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-40, kStatusBarH, 40, 40)];
    [cancelBtn.titleLabel setFont:MY_FONT(15)];
    [cancelBtn setAdjustsImageWhenHighlighted:NO];
    [cancelBtn setTitleColor:COLOR_STRING(@"#666666") forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:cancelBtn];
    
    UIButton *bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)*0.5, self.view.frame.size.height-91, 200, 43)];
    bottomBtn.backgroundColor = COLOR_STRING(@"#FEA449");
    bottomBtn.layer.cornerRadius = 22;
    [bottomBtn setTitle:@"确认上传" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:COLOR_STRING(@"#ffffff") forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(uploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
}

-(void)backButtonClick:(id)sender
{
    [self.imageArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelButtonClick:(UIButton*)btn{
    NSUInteger index = self.navigationController.viewControllers.count-3>=0?self.navigationController.viewControllers.count-3:0;
    ;
    [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];}
-(void)backSaoView{
    
    [self.imageArray removeAllObjects];
    
    NSUInteger index = self.navigationController.viewControllers.count-4>=0?self.navigationController.viewControllers.count-4:0;
    ;
    [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
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

- (void)uploadBtnClick{
    [self showBusyTip];
    [XBKNetWorkManager requestBookRegisterPictureWithImageArray:self.imageArray AndAndFinish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
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
    BKUploadingTipCtr *ctr = [[BKUploadingTipCtr alloc]initWithTitle:@"上传成功" andDes:@"小布会尽快上架" andleftBtnTitle:@"返回首页" andrightBtnTitle:@"继续上传" andIconName:@"uploadsuccesstip"];
    ctr.view.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
    ctr.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [ctr setUploadTipLeftBtnClick:^{
        [self backSaoView];
    }];
    [ctr setUploadTipRightBtnClick:^{
        [self.imageArray removeAllObjects];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self presentViewController:ctr animated:NO completion:^{
        
    }];
}
-(void)uploadingFail{
    BKUploadingTipCtr *ctr = [[BKUploadingTipCtr alloc]initWithTitle:@"上传失败" andDes:@"建议检查你的网络是否顺畅" andleftBtnTitle:@"返回首页" andrightBtnTitle:@"重新上传" andIconName:@"uploadsuccesstip"];
    ctr.view.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
    ctr.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [ctr setUploadTipLeftBtnClick:^{
        [self backSaoView];
    }];
    [ctr setUploadTipRightBtnClick:^{
        
    }];
    [self presentViewController:ctr animated:NO completion:^{
        
    }];
}

@end
