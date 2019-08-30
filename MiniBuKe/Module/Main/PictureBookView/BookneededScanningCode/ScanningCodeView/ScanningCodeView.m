//
//  ScanningCodeView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ScanningCodeView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIResponder+Event.h"
#import "English_Header.h"
/** 扫描内容的y值 */
#define scanContent_Y self.bounds.size.height/2 - SCALE(258)/2 - 20
/** 扫描内容的x值 */
#define scanContent_X SCALE(58.5)
/** 扫描内容的h值 */
#define scanContent_H SCALE(258)
/** 扫描内容的w值 */
#define scanContent_W self.frame.size.width - 2 * scanContent_X
@interface ScanningCodeView()
{
    BOOL isfirst;
}
@property (nonatomic, strong) UIView *basedView;
@property (nonatomic, strong) AVCaptureDevice *device;
@property(nonatomic,strong)UIImageView *animation_line;
@property(nonatomic,strong)UIButton *lightBtn;
@property(nonatomic,strong)UIButton *photoGraphBtn;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIView *leftView;
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,strong)UIView *scanContentView;
@property(nonatomic,strong) UIImageView *left_imageView;
@property(nonatomic,strong) UIImageView *right_imageView;
@property(nonatomic,strong) UIImageView *left_imageView_down;
@property(nonatomic,strong) UIImageView *right_imageView_down;
@end
@implementation ScanningCodeView
/** 扫描动画线(冲击波) 的高度 */
static CGFloat const animation_line_H = 9;
/** 扫描内容外部View的alpha值 */
static CGFloat const scanBorderOutsideViewAlpha = 0.4;

- (instancetype)initWithFrame:(CGRect)frame outsideViewLayer:(UIView *)outsideView
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.photoGraphBtn];
        [self.photoGraphBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(86, 86));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-120);
        }];
        _basedView= outsideView;
        // 创建扫描边框
    }
    return self;
}
+ (instancetype)scanningQRCodeViewWithFrame:(CGRect)frame outsideViewLayer:(UIView *)outsideViewLayer
{
    return [[self alloc] initWithFrame:frame outsideViewLayer:outsideViewLayer];
}

#pragma mark - 懒加载
-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]init];
//        _topView.backgroundColor = [UIColor blackColor] ;
        _topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha];

    }
    return _topView;
}
-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
//        _bottomView.backgroundColor = [UIColor blackColor] ;
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha];

    }
    return _bottomView;
}
-(UIView *)leftView
{
    if (!_leftView) {
        _leftView = [[UIView alloc]init];
//        _leftView.backgroundColor = [UIColor blackColor] ;
        _leftView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha];

    }
    return _leftView;
}
-(UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc]init];
//        _rightView.backgroundColor = [UIColor blackColor] ;
        _rightView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha];

    }
    return _rightView;
}

-(UIView *)scanContentView
{
    if (!_scanContentView) {
     
        // 扫描内容的创建
        UIView *scanContentView = [[UIView alloc] init];
        CGFloat scanContentViewX = scanContent_X;
        CGFloat scanContentViewY = scanContent_Y;
        CGFloat scanContentViewW = scanContent_W;
        CGFloat scanContentViewH = scanContent_H;
        scanContentView.frame = CGRectMake(scanContentViewX, scanContentViewY, scanContentViewW, scanContentViewH);
        scanContentView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
        scanContentView.layer.borderWidth = 0.7;
        scanContentView.layer.cornerRadius = SCALE(9);
        scanContentView.layer.masksToBounds = YES;
        scanContentView.backgroundColor = [UIColor clearColor];
        [self addSubview:scanContentView];
        
        
        // 提示Label
        UILabel *promptLabel = [[UILabel alloc] init];
        promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = self.frame.size.width/2 -  SCALE(250)/2;
        CGFloat promptLabelY = scanContent_X * 0.5;
        CGFloat promptLabelW = SCALE(250);
        CGFloat promptLabelH = 27;
        promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        promptLabel.textAlignment = NSTextAlignmentCenter;
        promptLabel.font = [UIFont boldSystemFontOfSize:SCALE(13.0)];
        promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        promptLabel.text = @"条形码/二维码放入框内, 即可自动扫描";
        promptLabel.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
        promptLabel.layer.borderWidth = 1;
        promptLabel.layer.cornerRadius = 14;
        [self.bottomView addSubview:promptLabel];
        self.promptLabel = promptLabel;
        // 左上侧的image
        CGFloat margin = 10;
        
        UIImage *left_image = [UIImage imageNamed:@"round1"];
        UIImageView *left_imageView = [[UIImageView alloc] init];
        CGFloat left_imageViewX = CGRectGetMinX(scanContentView.frame) - left_image.size.width * 0.5 + margin;
        CGFloat left_imageViewY = CGRectGetMinY(scanContentView.frame) - left_image.size.width * 0.5 + margin;
        CGFloat left_imageViewW = left_image.size.width;
        CGFloat left_imageViewH = left_image.size.height;
        left_imageView.frame = CGRectMake(left_imageViewX, left_imageViewY, left_imageViewW, left_imageViewH);
        left_imageView.image = left_image;
        
        [self addSubview:left_imageView];
        [self bringSubviewToFront:left_imageView];
        self.left_imageView = left_imageView;
        
        // 右上侧的image
        UIImage *right_image = [UIImage imageNamed:@"round2"];
        UIImageView *right_imageView = [[UIImageView alloc] init];
        CGFloat right_imageViewX = CGRectGetMaxX(scanContentView.frame) - right_image.size.width * 0.5 - margin;
        CGFloat right_imageViewY = left_imageView.frame.origin.y;
        CGFloat right_imageViewW = left_image.size.width;
        CGFloat right_imageViewH = left_image.size.height;
        right_imageView.frame = CGRectMake(right_imageViewX, right_imageViewY, right_imageViewW, right_imageViewH);
        right_imageView.image = right_image;
        
        [self addSubview:right_imageView];
        [self bringSubviewToFront:right_imageView];
        self.right_imageView = right_imageView;
        
        // 左下侧的image
        UIImage *left_image_down = [UIImage imageNamed:@"round3"];
        UIImageView *left_imageView_down = [[UIImageView alloc] init];
        CGFloat left_imageView_downX = left_imageView.frame.origin.x;
        CGFloat left_imageView_downY = CGRectGetMaxY(scanContentView.frame) - left_image_down.size.width * 0.5 - margin;
        CGFloat left_imageView_downW = left_image.size.width;
        CGFloat left_imageView_downH = left_image.size.height;
        left_imageView_down.frame = CGRectMake(left_imageView_downX, left_imageView_downY, left_imageView_downW, left_imageView_downH);
        left_imageView_down.image = left_image_down;
        
        [self addSubview:left_imageView_down];
        [self bringSubviewToFront:left_imageView_down];
        self.left_imageView_down = left_imageView_down;
        
        // 右下侧的image
        UIImage *right_image_down = [UIImage imageNamed:@"round4"];
        UIImageView *right_imageView_down = [[UIImageView alloc] init];
        CGFloat right_imageView_downX = right_imageView.frame.origin.x;
        CGFloat right_imageView_downY = left_imageView_down.frame.origin.y;
        CGFloat right_imageView_downW = left_image.size.width;
        CGFloat right_imageView_downH = left_image.size.height;
        right_imageView_down.frame = CGRectMake(right_imageView_downX, right_imageView_downY, right_imageView_downW, right_imageView_downH);
        right_imageView_down.image = right_image_down;
       
        [self addSubview:right_imageView_down];
        [self bringSubviewToFront:right_imageView_down];
        self.right_imageView_down = right_imageView_down;
        
        _scanContentView = scanContentView;
        
    }
    return _scanContentView;
}
-(UIImageView *)animation_line
{
    if (!_animation_line) {
        _animation_line = [[UIImageView alloc] init];
        _animation_line.image = [UIImage imageNamed:@"moving_line"];
        _animation_line.frame = CGRectMake(scanContent_X , scanContent_Y - animation_line_H, self.frame.size.width - 2*scanContent_X , animation_line_H);
    }
    return _animation_line;
}
-(UIButton *)photoGraphBtn
{
    if (!_photoGraphBtn) {
        
        _photoGraphBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoGraphBtn setImage:[UIImage imageNamed:@"photograph"] forState:UIControlStateNormal];
        [_photoGraphBtn addTarget:self action:@selector(photoGraph:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoGraphBtn;
}

#pragma mark - action
-(void)photoGraph:(UIButton*)btn{
    [self eventName:ScanningCodeView_Event Params:photoGraphEvent];

    
}
#pragma mark - 扫码UI
// 创建扫描边框
- (void)setupScanningQRCodeEdging {
    
    self.photoGraphBtn.hidden = YES;
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    [self addSubview:self.scanContentView];
    [self sendSubviewToBack:self.scanContentView];

    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(scanContent_Y);

    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(self.bounds.size.height - CGRectGetMaxY(self.scanContentView.frame));

    }];

    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.scanContentView.mas_top);
        make.bottom.mas_equalTo(self.scanContentView.mas_bottom);
        make.width.mas_equalTo(scanContent_X);
    }];

    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.scanContentView.mas_top);
        make.bottom.mas_equalTo(self.scanContentView.mas_bottom);
        make.width.mas_equalTo(self.bounds.size.width - CGRectGetMaxX(self.scanContentView.frame));

    }];
    
    
    
    [self ScanAnimation];
    
}

#pragma mark - 相册

#pragma mark - 扫描动画
-(void)ScanAnimation{
    
    // 扫描动画添加
   
    [self addSubview:self.animation_line];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.duration = 2;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSNumber numberWithDouble:scanContent_Y - animation_line_H];
    animation.toValue =[NSNumber numberWithDouble:scanContent_Y + SCALE(258)];;
    [self.animation_line.layer addAnimation:animation forKey:nil];
    
}

-(void)setFuncMode:(FuncMode)funcMode
{
    
    _funcMode = funcMode;
    if (funcMode ==  ScanCodeMode)
    {
        
        //扫描
      
        self.photoGraphBtn .hidden=YES;
        if (!isfirst) {
        
           [self setupScanningQRCodeEdging];
            isfirst = YES;
        }else
        {

            [self PhotoGraphToScanAnimation];
        }
    
    }else
    {
        
        //照相
        [self ScanToPhotoGraphAnimation];

    }
}

#pragma mark - 切换模式动画
/**扫码切换为照相 */
-(void)ScanToPhotoGraphAnimation{
    [self.animation_line.layer removeAllAnimations];
//    for (UIView * subview in self.subviews) {
//        if ([subview isKindOfClass:[UIImageView class]]) {
//            [subview removeFromSuperview];
//        }
//    }
    self.left_imageView.hidden = YES;
    self.left_imageView_down.hidden= YES;
    self.right_imageView.hidden = YES;
    self.right_imageView_down.hidden = YES;
    self.animation_line.hidden = YES;
    self.photoGraphBtn .hidden=NO;
    [UIView animateWithDuration:0.5 animations:^{

        self.scanContentView.frame = self.bounds;
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.leftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        [self.rightView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        [self layoutIfNeeded];

    } completion:^(BOOL finished) {
        
      
        self.left_imageView.hidden = YES;
        self.left_imageView_down.hidden= YES;
        self.right_imageView.hidden = YES;
        self.right_imageView_down.hidden = YES;
        self.animation_line.hidden = YES;
         self.photoGraphBtn .hidden=NO;
    
    }];
    
    
    
}


/**照相切换为扫码 */

-(void)PhotoGraphToScanAnimation{
    
    self.photoGraphBtn .hidden=YES;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.scanContentView.frame = CGRectMake(scanContent_X, scanContent_Y, scanContent_W, scanContent_H);
       
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(scanContent_Y);
        }];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.bounds.size.height - CGRectGetMaxY(self.scanContentView.frame));
        }];
        [self.leftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(scanContent_X);
        }];
        [self.rightView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.bounds.size.width - CGRectGetMaxX(self.scanContentView.frame));
        }];
        [self layoutIfNeeded];

        
    } completion:^(BOOL finished) {
       

        self.left_imageView.hidden = NO;
        self.left_imageView_down.hidden= NO;
        self.right_imageView.hidden = NO;
        self.right_imageView_down.hidden = NO;
        self.animation_line.hidden = NO;
        self.photoGraphBtn .hidden=YES;
         [self ScanAnimation];
    }];
    
}


@end
