//
//  BKLoginCodeTip.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKLoginCodeTip.h"
#define Animationduration 0.4
#define delayTime 1.5

@interface BKLoginCodeTip()

@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *title;

@end

@implementation BKLoginCodeTip

- (void)addTipWithView:(UIView*)view WithImage:(NSString*)imageName and:(CGSize)size andTitle:(NSString*)title {
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    bottomView.backgroundColor = [UIColor clearColor];
    self.tipView.frame = bottomView.frame;
    [bottomView addSubview:self.tipView];
    
    self.iconImageView.frame = CGRectMake((size.width-55)*0.5, 20, 55, 55);
    self.iconImageView.image = [UIImage imageNamed:imageName];
    [bottomView addSubview:self.iconImageView];
    
    self.title.frame = CGRectMake(0, 90, size.width, 15);
    self.title.text = title;
    [bottomView addSubview:self.title];
    bottomView.alpha = 0;
    bottomView.center = CGPointMake(view.center.x, view.center.y+58);
    
    [UIView animateWithDuration:0.25 animations:^{
        [view addSubview:bottomView];
        bottomView.alpha = 1;
    }completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:Animationduration animations:^{
                bottomView.alpha = 0;
            }completion:^(BOOL finished) {
                [bottomView removeFromSuperview];
            }];
        });
    }];
}

- (void)addTipTextWithView:(UIView*)view and:(CGSize)size andTitle:(NSString*)title{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    bottomView.backgroundColor = [UIColor clearColor];
    self.tipView.frame = bottomView.frame;
    [bottomView addSubview:self.tipView];
    
    self.title.frame = bottomView.frame;
    self.title.text = title;
    _tipView.layer.cornerRadius = 20;
    [bottomView addSubview:self.title];
    bottomView.alpha = 0;
    bottomView.center = CGPointMake(view.center.x, view.center.y+58);
    
    [UIView animateWithDuration:0.25 animations:^{
        [view addSubview:bottomView];
        bottomView.alpha = 1;
    }completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:Animationduration animations:^{
                bottomView.alpha = 0;
            }completion:^(BOOL finished) {
                [bottomView removeFromSuperview];
            }];
        });
    }];
}

- (void)AddBindWeChartOkTip:(UIView*)view{
    [self addTipWithView:view WithImage:@"login_codeSend_icon" and:CGSizeMake(115, 122) andTitle:@"绑定成功"];
}

- (void)AddBindWeChartFailTip:(UIView*)view{
    [self addTipTextWithView:view and:CGSizeMake(131,40) andTitle:@"授权失败"];
}

- (void)AddCodeSendOkTip:(UIView*)view{
    [self addTipWithView:view WithImage:@"login_codeSend_icon" and:CGSizeMake(164, 122) andTitle:@"短信验证码已发送"];
}

- (void)AddCodeIsErrorTip:(UIView*)view{
    [self addTipWithView:view WithImage:@"login_codeError_icon" and:CGSizeMake(125, 122) andTitle:@"验证码错误"];
}

- (void)AddFeedbackOkTip:(UIView*)view{
    
    [self addTipWithView:view WithImage:@"login_codeSend_icon" and:CGSizeMake(125, 122) andTitle:@"反馈成功"];
}
- (void)codeInvalidTip:(UIView*)view Info:(NSString*)info{
    
     [self addTipWithView:view WithImage:@"login_codeError_icon" and:CGSizeMake(125, 122) andTitle:info];
    
}
- (void)ActivicodeSuccess:(UIView*)view{
    
    [self addTipWithView:view WithImage:@"login_codeSend_icon" and:CGSizeMake(125, 122) andTitle:@"激活成功!"];
}
- (void)AddLoginNetErrorTip:(UIView*)view{
    [self addTipTextWithView:view and:CGSizeMake(202,40) andTitle:@"啊哦~网络连接失败了"];
}

- (void)AddLoginRequestErrorTip:(UIView*)view{
    [self addTipTextWithView:view and:CGSizeMake(202,40) andTitle:@"啊哦~请求出错了"];
}

- (void)AddTextShowTip:(NSString*)tipStr and:(UIView*)view{
    CGFloat w = [self measureSinglelineStringWidth:tipStr andFont:_title.font]+80;
    if (w >= SCREEN_WIDTH) {
        w = SCREEN_WIDTH-80;
        self.title.numberOfLines = 0;
        [self addTipTextWithView:view and:CGSizeMake(w,80) andTitle:tipStr];
    }else{
        [self addTipTextWithView:view and:CGSizeMake(w,40) andTitle:tipStr];
    }
}

#pragma mark - lazy
- (UIView *)tipView{
    if (_tipView == nil) {
        _tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 164, 122)];
        _tipView.layer.cornerRadius = 9.f;
        _tipView.backgroundColor = COLOR_STRING(@"#2f2f2f");
        _tipView.alpha = 0.9;
    }
    return _tipView;
}

- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 55, 55)];
    }
    return _iconImageView;
}

- (UILabel *)title{
    if (_title == nil) {
        _title = [[UILabel alloc]init];
        _title.font = [UIFont systemFontOfSize:13.f];
        _title.textColor = COLOR_STRING(@"#ffffff");
        _title.textAlignment = NSTextAlignmentCenter;
        _title.numberOfLines = 0;
    }
    return _title;
}

-(float)measureSinglelineStringWidth:(NSString*)str andFont:(UIFont*)wordFont{
    if (str == nil) return 0;
    CGSize measureSize;
    measureSize = [str boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, nil] context:nil].size;
    
    return ceil(measureSize.width);
}

@end
