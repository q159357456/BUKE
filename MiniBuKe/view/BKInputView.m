//
//  BKInputView.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKInputView.h"

@implementation BKInputView{
    UIImageView *iconImageView;
    UIView *leftView;
    CGRect leftRect;
    CGRect iconRect;
}

-(instancetype)init{
    self  = [super init];
    if(self){
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)setImageFrame:(CGRect)rect{
    leftRect = rect;
}

-(void)setIconFrame:(CGRect)rect
{
    iconRect = rect;
}

-(void)layoutSubviews{
    [_inputText addBottomBorder:_borderW];
    [iconImageView setImage:_icon];
    [self addConstraints];
    [super layoutSubviews];
}



-(void)addConstraints{
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(leftRect.size.width, leftRect.size.height));
        make.left.equalTo(self).with.offset(leftRect.origin.x);
        make.centerY.equalTo(self);
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(iconRect.size.width, iconRect.size.height));
        make.center.equalTo(leftView);
    }];
    
    if(_rightView==nil){
        [_inputText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_left).with.offset(25);
            make.top.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self);
        }];
    }else{
        [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(_rightView.frame.size.width);
            make.right.equalTo(self).with.offset(0);
            make.top.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
            make.centerY.equalTo(self);
        }];
        
        [_inputText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_left).with.offset(25);
            make.right.equalTo(_rightView.mas_left).with.offset(-10);
            make.top.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
            make.centerY.equalTo(self);
        }];
    }
}

-(void)setRightView:(UIView *)rightView{
    _rightView = rightView;
    [self addSubview:_rightView];
}

-(void)initView{
    
    leftRect = CGRectMake(0, 0, 16, 16);
    iconRect = CGRectMake(0, 0, 16, 16);
    _borderW = 0.5f;
    
    leftView = [[UIView alloc] init];
    [leftView setFrame:leftRect];
    
    iconImageView = [[UIImageView alloc] init];
    _inputText = [[UITextField alloc] init];
    
    
    [self addSubview:leftView];
    [leftView addSubview:iconImageView];
    [self addSubview:_inputText];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
