//
//  BKLoginCodeInputView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKLoginCodeInputView.h"
#define countS 60
@interface BKLoginCodeInputView()

@property(nonatomic, strong) UITextField *codeInputText;
@property(nonatomic, strong) UIButton *codeSendBtn;
@property(nonatomic, assign) BOOL isEnabelSend;

@property(nonatomic, weak) NSTimer *showTimer;
@property(assign, nonatomic) NSTimeInterval showTime;

@end

@implementation BKLoginCodeInputView

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
    
    self.codeInputText = [[UITextField alloc]init];
    [_codeInputText setKeyboardType:UIKeyboardTypeNumberPad];
    [_codeInputText setPlaceholder:@"请输入短信验证码"];
    [_codeInputText setFont:[UIFont systemFontOfSize:16.f]];
    _codeInputText.tintColor = COLOR_STRING(@"#FA9A3A");
    _codeInputText.tag = 99;
    [self addSubview:_codeInputText];
    
    
    self.codeSendBtn = [[UIButton alloc]init];
    _codeSendBtn.backgroundColor = COLOR_STRING(@"#d7d7d7");
    [_codeSendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeSendBtn setTitleColor:COLOR_STRING(@"#FFFFFF") forState:UIControlStateNormal];
    _codeSendBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    _codeSendBtn.layer.cornerRadius = 13.f;
    _codeSendBtn.clipsToBounds = YES;
    [_codeSendBtn addTarget:self action:@selector(codeSendClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_codeSendBtn];
    
    self.showTime = countS;
    [self addConstraints];
}

-(void)changeSendCodeBtnUIWithEnabel:(BOOL)isEnabel{
    if (self.showTime < countS) {
        return;
    }
    if (isEnabel) {
        [_codeSendBtn setBackgroundColor:COLOR_STRING(@"#FEA449")];
    }else{
        [_codeSendBtn setBackgroundColor:COLOR_STRING(@"#d7d7d7")];
    }
    _isEnabelSend = isEnabel;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)addConstraints{
    [self.codeSendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(85.f);
        make.height.mas_equalTo(25.f);
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.centerY.mas_equalTo(self.mas_centerY).offset(0);
    }];
    [self.codeInputText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.right.mas_equalTo(self.codeSendBtn.mas_left).offset(0);
    }];
}

-(void)startFirstResponder{
    [self.codeInputText becomeFirstResponder];
}
-(void)cancelFirstResponder{
    [self.codeInputText resignFirstResponder];
}

- (void)codeSendClick:(UIButton*)btn{
    if (!self.isEnabelSend) {
        return;
    }
    if (_sendCodeBtnClick) {
        _sendCodeBtnClick();
    }
}

/**开启60S倒计时操作*/
-(void)beginStartCountDown{
    [self addShowTimer];
    self.isEnabelSend = NO;
}

#pragma mark - 定时器
/**添加定时器*/
- (void)addShowTimer
{
    [self removeShowTimer];
    [self changeSendCodeBtnUIWithEnabel:NO];
    [_codeSendBtn setTitle:[NSString stringWithFormat:@"%ds",countS] forState:UIControlStateNormal];

    self.showTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateShowTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.showTimer forMode:NSRunLoopCommonModes];
}
/**移除定时器*/
- (void)removeShowTimer
{
    [self.showTimer invalidate];
    self.showTimer = nil;
    self.showTime = countS;
}

/**定时器回调*/
- (void)updateShowTime
{
    self.showTime -= 1;
    if (self.showTime >= 0) {
        [_codeSendBtn setTitle:[NSString stringWithFormat:@"%lds",(NSInteger)self.showTime] forState:UIControlStateNormal];
        self.isEnabelSend = NO;
    }else{
        [self removeShowTimer];
        [_codeSendBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
        [self changeSendCodeBtnUIWithEnabel:YES];
    }
}

- (void)dealloc{
    [self removeShowTimer];
}

@end
