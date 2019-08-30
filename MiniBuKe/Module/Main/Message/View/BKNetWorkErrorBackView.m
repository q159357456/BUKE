//
//  BKNetWorkErrorBackView.m
//  MiniBuKe
//
//  Created by chenheng on 2019/2/19.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKNetWorkErrorBackView.h"

@interface BKNetWorkErrorBackView()

@property (nonatomic ,strong) UIButton *tryAgainBtn;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,assign) CGRect imageBound;
@property(nonatomic,assign) CGFloat picOffset;
@property(nonatomic,assign) CGFloat lableOffset;
@property(nonatomic,strong) UIFont *titlefont;
@property(nonatomic,strong) UIColor *titlefontColor;
@end

@implementation BKNetWorkErrorBackView

+(instancetype)showOn:(UIView*)view WithFrame:(CGRect)rect{
    CGRect imageBound = CGRectMake(0, 0, 375, 172);
    
    UIImage *backImage = [UIImage imageNamed:@"netError_back_icon"];
    NSString *title = @"您的网络不太给力\n请检查网络设置或稍后重试";
    BKNetWorkErrorBackView *backView = [[BKNetWorkErrorBackView alloc]initWithImageBound:imageBound WithImage:backImage WithTitle:title andPicOffset:-100 andLableOffset:8];
    backView.frame = rect;
    backView.backgroundColor = COLOR_STRING(@"#FAFAFA");
    backView.titlefont = [UIFont systemFontOfSize:13.f];
    backView.titlefontColor = COLOR_STRING(@"#999999");
    
    [view addSubview:backView];
    
    return backView;
}

-(instancetype)initWithImageBound:(CGRect)imageBound WithImage:(UIImage *)image WithTitle:(NSString *)title andPicOffset:(CGFloat)picOffset andLableOffset:(CGFloat)lableOffset{
    if (self = [super init]) {
        
        self.imageBound = imageBound;
        self.picOffset = picOffset;
        self.lableOffset = lableOffset;
        
        self.imageView.image = image;
        [self addSubview:self.imageView];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        self.label.attributedText = str;
        [self addSubview:self.label];
        
        self.tryAgainBtn = [[UIButton alloc]init];
        [self.tryAgainBtn setTitle:@"刷新重试" forState:UIControlStateNormal];
        [self.tryAgainBtn setTitle:@"刷新重试" forState:UIControlStateSelected];
        self.tryAgainBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [self.tryAgainBtn setTitleColor:COLOR_STRING(@"#FA9A3A") forState:UIControlStateNormal];
        [self.tryAgainBtn setTitleColor:COLOR_STRING(@"#FA9A3A") forState:UIControlStateSelected];
        
        self.tryAgainBtn.layer.borderWidth = 1;
        self.tryAgainBtn.layer.borderColor = COLOR_STRING(@"#F9A055").CGColor;
        self.tryAgainBtn.layer.cornerRadius = 22.f;
        self.tryAgainBtn.clipsToBounds = YES;
        [self.tryAgainBtn addTarget:self action:@selector(tryAgain) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.tryAgainBtn];
    }
    return self;
}

-(UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

-(UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = COLOR_STRING(@"#9B9B9B");
        _label.font = MY_FONT(15);
        _label.numberOfLines = 0;
    }
    
    return _label;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.titlefont) {
        self.label.font = self.titlefont;
    }
    if (self.titlefontColor) {
        self.label.textColor = self.titlefontColor;
    }
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).mas_equalTo(self.picOffset);
        make.width.mas_equalTo(self.imageBound.size.width);
        make.height.mas_equalTo(self.imageBound.size.height);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(self.lableOffset);
    }];
    [self.tryAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.label.mas_bottom).offset(52.f);
    }];
    [self layoutIfNeeded];
}

- (void)tryAgain{
    [self removeFromSuperview];
    self.tryAgainAction();
}
@end
