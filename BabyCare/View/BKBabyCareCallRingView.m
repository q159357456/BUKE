//
//  BKBabyCareCallRingView.m
//  MiniBuKe
//
//  Created by chenheng on 2019/5/5.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBabyCareCallRingView.h"

@interface BKBabyCareCallRingView()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *answerBtn;
@property (nonatomic, strong) UIButton *refuseBtn;
@property (nonatomic, strong) UILabel *titleAnswer;
@property (nonatomic, strong) UILabel *titleRefuse;
@end

@implementation BKBabyCareCallRingView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        self.frame = [UIScreen mainScreen].bounds;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.iconView = [[UIImageView alloc]init];
    self.iconView.image = [UIImage imageNamed:@"bc_ringCall_topicon"];
    [self addSubview:self.iconView];
    
    self.title = [[UILabel alloc]init];
    self.title.text = @"宝贝打来电话想和你聊天";
    self.title.textColor = [UIColor whiteColor];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.font = [UIFont systemFontOfSize:18.f];
    [self addSubview:self.title];
    
    self.refuseBtn = [[UIButton alloc]init];
    [self.refuseBtn setImage:[UIImage imageNamed:@"bc_ringCall_refuse"] forState:UIControlStateNormal];
    [self.refuseBtn addTarget:self action:@selector(refuseRing:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.refuseBtn];
    
    self.answerBtn = [[UIButton alloc]init];
    [self.answerBtn setImage:[UIImage imageNamed:@"bc_ringCall_answer"] forState:UIControlStateNormal];
    [self.answerBtn addTarget:self action:@selector(answerRing:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.answerBtn];
    
    self.titleAnswer = [[UILabel alloc]init];
    self.titleAnswer.text = @"接听";
    self.titleAnswer.textColor = [UIColor whiteColor];
    self.titleAnswer.textAlignment = NSTextAlignmentCenter;
    self.titleAnswer.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:self.titleAnswer];
    
    self.titleRefuse = [[UILabel alloc]init];
    self.titleRefuse.text = @"拒绝";
    self.titleRefuse.textColor = [UIColor whiteColor];
    self.titleRefuse.textAlignment = NSTextAlignmentCenter;
    self.titleRefuse.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:self.titleRefuse];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;

    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(56+kStatusBarH);
        make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
        make.width.height.mas_equalTo(100);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.iconView.mas_centerX).offset(0);
        make.top.equalTo(weakSelf.iconView.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
    }];
    [self.answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(65);
        make.centerX.equalTo(weakSelf.mas_centerX).offset(62+65*0.5);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-55);
    }];
    [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(65);
        make.centerX.equalTo(weakSelf.mas_centerX).offset(-62-65*0.5);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-55);
    }];
    [self.titleAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.centerX.equalTo(weakSelf.answerBtn.mas_centerX).offset(0);
        make.top.equalTo(weakSelf.answerBtn.mas_bottom).offset(20);
    }];
    [self.titleRefuse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.centerX.equalTo(weakSelf.refuseBtn.mas_centerX).offset(0);
        make.top.equalTo(weakSelf.refuseBtn.mas_bottom).offset(20);
    }];
}

- (void)refuseRing:(UIButton*)btn{
    [self removeFromSuperview];
    self.BtnClick(NO);
}
- (void)answerRing:(UIButton*)btn{
    [self removeFromSuperview];
    self.BtnClick(YES);
}

@end
