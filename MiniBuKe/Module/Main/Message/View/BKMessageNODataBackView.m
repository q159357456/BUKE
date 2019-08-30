//
//  BKMessageNODataBackView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKMessageNODataBackView.h"
@interface BKMessageNODataBackView()

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,assign) CGRect imageBound;
@property(nonatomic,assign) CGFloat picOffset;
@property(nonatomic,assign) CGFloat lableOffset;

@end
@implementation BKMessageNODataBackView

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
    [self layoutIfNeeded];
}

@end
