//
//  BKLoginPhoneInputView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKLoginPhoneInputView.h"

@interface BKLoginPhoneInputView()

@property(nonatomic, strong) UITextField *phoneInputText;
@property(nonatomic, strong) UIButton *areaCodeBtn;
@property(nonatomic, strong) UILabel *areaCodeShow;
@property(nonatomic, strong) UIImageView *SelectIcon;

@end

@implementation BKLoginPhoneInputView

- (instancetype)init{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 25;
    self.layer.borderWidth = 1;
    self.layer.borderColor = COLOR_STRING(@"#eaeaea").CGColor;
    self.backgroundColor = COLOR_STRING(@"#FFFFFF");
    
    self.phoneInputText = [[UITextField alloc]init];
    [_phoneInputText setKeyboardType:UIKeyboardTypeNumberPad];
    [_phoneInputText setPlaceholder:@"请输入手机号"];
    [_phoneInputText setFont:[UIFont systemFontOfSize:16.f]];
    _phoneInputText.tintColor = COLOR_STRING(@"#FA9A3A");
    _phoneInputText.tag = 66;
    [self addSubview:_phoneInputText];
    
    self.SelectIcon = [[UIImageView alloc]init];
    self.SelectIcon.image = [UIImage imageNamed:@"login_select_icon"];
    [self addSubview:_SelectIcon];

    self.areaCodeBtn = [[UIButton alloc]init];
    [self.areaCodeBtn addTarget:self action:@selector(areaSelectClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_areaCodeBtn];
    
    self.areaCodeShow = [[UILabel alloc]init];
    self.areaCodeShow.textColor = COLOR_STRING(@"#2f2f2f");
    self.areaCodeShow.textAlignment = NSTextAlignmentCenter;
    self.areaCodeShow.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightRegular];
    self.areaCodeShow.text = @"+86";
    [self addSubview:_areaCodeShow];
    [self addConstraints];
}

- (void)dealloc{
    [self cancelFirstResponder];
}

- (void)layoutSubviews{
    [super layoutSubviews];

}

- (void)addConstraints{
    [self.areaCodeShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    [self.SelectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.areaCodeShow.mas_right).offset(10);
        make.width.mas_equalTo(9.f);
        make.height.mas_equalTo(8.f);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.areaCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.areaCodeShow.mas_left).offset(0);
        make.right.mas_equalTo(self.SelectIcon.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    [self.phoneInputText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.areaCodeBtn.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
}
-(void)startFirstResponder{
    [self.phoneInputText becomeFirstResponder];
}
-(void)cancelFirstResponder{
    [self.phoneInputText resignFirstResponder];
}

- (void)areaSelectClick{
    if (_areaSelectBlock) {
        _areaSelectBlock();
    }
}
/**改变地区区号*/
- (void)changeThePhoneArea:(NSString*)str{
    self.areaCodeShow.text = [NSString stringWithFormat:@"+%@",str];
    [self layoutIfNeeded];
}
- (void)changeThePhoneNumber:(NSString*)str{
    self.phoneInputText.text = str;
}

- (NSString*)GetThePhoneAreaNUmber{
    return self.areaCodeShow.text;
}

@end
