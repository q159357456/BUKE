//
//  QLVideoNoWiFiTipView.m
//  QLMediaPlayer
//
//  Created by Don on 16/5/10.
//  Copyright © 2016年 Don. All rights reserved.
//

#import "QLVideoNoWiFiTipView.h"
#import "Masonry.h"

@interface QLVideoNoWiFiTipView()
@property(nonatomic,strong)UILabel *label1;

@property(nonatomic,strong)UIButton *GoPlayBtn;
@property(nonatomic,strong)UIButton *CancelPlayBtn;

@end

@implementation QLVideoNoWiFiTipView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:0.8];
    }
    return self;
}

-(void)setup{
    
    self.label1= [[UILabel alloc]init];
    _label1.textColor = [UIColor whiteColor];
    _label1.font = [UIFont systemFontOfSize:13.f];
    _label1.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"您正在使用非wifi网络，继续观看将产生流量费用" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]}];
    _label1.attributedText = string;
    [self addSubview:_label1];
    
    UIButton *GoPlayBtn = [[UIButton alloc]init];
    self.GoPlayBtn = GoPlayBtn;
    [self.GoPlayBtn setImage:[UIImage imageNamed:@"bc_NoWifitip_go"] forState:UIControlStateNormal];
    [GoPlayBtn addTarget:self action:@selector(GoPlayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:GoPlayBtn];
    
    self.CancelPlayBtn = [[UIButton alloc]init];
    [self.CancelPlayBtn setImage:[UIImage imageNamed:@"bc_NoWifitip_cancel"] forState:UIControlStateNormal];
    [_CancelPlayBtn addTarget:self action:@selector(CancelPlayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_CancelPlayBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
        
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(-30);
    }];
    [self.GoPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_centerX).with.offset(-15);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(90);
        make.top.mas_equalTo(weakSelf.label1.mas_bottom).with.offset(10);
    }];
    [self.CancelPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_centerX).with.offset(15);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(90);
        make.top.mas_equalTo(weakSelf.label1.mas_bottom).with.offset(10);
    }];
}

-(void)GoPlayBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(VideoNoWiFiTipGoPlay)]) {
        [self.delegate VideoNoWiFiTipGoPlay];
    }
}

-(void)CancelPlayBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(VideoNoWiFiTipCancelPlay)]) {
        [self.delegate VideoNoWiFiTipCancelPlay];
    }
}

@end
