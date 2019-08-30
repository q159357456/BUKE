//
//  ARLockView.m
//  MiniBuKe
//
//  Created by chenheng on 2019/5/13.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "ARLockView.h"
#import "ARManager.h"
#import "ARRecognitionView.h"
#import "ARReportUpLoadManager.h"
#import "ARReportEndTimeHandle.h"
@interface ARLockView ()
@property(nonatomic,strong)NSArray * questionsData;
@property(nonatomic,strong)NSArray *valuesData;
@property(nonatomic,strong)UIButton *doneButton;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UITextField *textfield;
@property(nonatomic,copy)void (^doneBlock)(void);
@end
@implementation ARLockView

+(instancetype)showLockInfoCallBack:(void(^)(void))block;
{
    ARLockView *lock = [[ARLockView alloc]init];
    lock.doneBlock = ^{
        block();
    };
    return lock;
}
-(instancetype)init
{
    if (self = [super init]) {
        self.frame = APP_DELEGATE.window.bounds;
        [APP_DELEGATE.window addSubview:self];
        self.backgroundColor = A_COLOR_STRING(0x191919, 0.8f);
        UIView *contenView = [[UIView alloc]init];
        self.contentView = contenView;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 24;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
        
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.image = [UIImage imageNamed:@"ar_lock"];
        [self addSubview:imageV];
        
        UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"ar_lock_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"输入正确答案确保您是家长";
        UILabel *questionLabel = [[UILabel alloc]init];
        questionLabel.textAlignment = NSTextAlignmentCenter;
        questionLabel.font = [UIFont boldSystemFontOfSize:30];
        questionLabel.textColor = COLOR_STRING(@"#56BA7D");
        UIView * fieldBackView = [[UIView alloc]init];
        fieldBackView.layer.cornerRadius = 22;
        fieldBackView.layer.masksToBounds = YES;
        fieldBackView.layer.borderWidth = 1.0f;
        fieldBackView.layer.borderColor = COLOR_STRING(@"#D7D7D7").CGColor;
        fieldBackView.backgroundColor = COLOR_STRING(@"#F6F6F6");
        UITextField *textfield = [[UITextField alloc]init];
        textfield.textAlignment = NSTextAlignmentCenter;
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneButton setBackgroundColor:COLOR_STRING(@"#F6922D")];
        [self.doneButton setTitle:@"确定" forState:UIControlStateNormal];
        self.doneButton.layer.cornerRadius = 22;
        self.doneButton.layer.masksToBounds = YES;
        [self.doneButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        //
        [self.contentView addSubview:label];
        [self.contentView addSubview:questionLabel];
        [self.contentView addSubview:fieldBackView];
        [self.contentView addSubview:self.doneButton];
        [fieldBackView addSubview:textfield];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(300, 269));
        }];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(200, 85));
            make.bottom.mas_equalTo(self.contentView.mas_top).offset(14);
        }];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_top).offset(-5);
            make.left.mas_equalTo(self.contentView.mas_right);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.contentView.mas_top).offset(30);
            make.size.mas_equalTo(CGSizeMake(300, 14));
        }];
        [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(label.mas_bottom).offset(33);
            make.size.mas_equalTo(CGSizeMake(300, 34));
        }];
        [fieldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerX.mas_equalTo(self);
             make.top.mas_equalTo(questionLabel.mas_bottom).offset(9);
             make.size.mas_equalTo(CGSizeMake(200, 44));
        }];
        [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(fieldBackView.mas_bottom).offset(34);
            make.size.mas_equalTo(CGSizeMake(200, 44));
        }];
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(fieldBackView);
            make.size.mas_equalTo(CGSizeMake(200, 14));
        }];
        
        
        self.textfield = textfield;
        self.random = arc4random() % 3;
        questionLabel.text = self.questionsData[self.random];
        
        [_textfield becomeFirstResponder];
        
    }
    return self;
}
-(NSArray *)questionsData
{
    if (!_questionsData) {
        
        _questionsData = @[@"9+12=?",@"14+13=?",@"18+32=?",@"19-6=?",@"45-12=?",@"24-8=?",@"9X3=?",@"11X4=?",@"12X3=?",@"15÷5=?"];
    }
    return _questionsData;
}

-(NSArray *)valuesData
{
    if (!_valuesData) {
        _valuesData = @[@"21",@"27",@"50",@"13",@"33",@"16",@"27",@"44",@"36",@"3"];
    }
    return _valuesData;
}

-(void)dismiss{
    
    if ([self.textfield.text isEqualToString:self.valuesData[self.random]]) {
        [ARManager onPause];
        [[ARAudioManager singleton] stopPlay];
        [ARAudioManager singleton].InEasyAR_Working = NO;
        [ARAudioManager singleton].isRead = NO;;
        [[ARRecognitionView singleton] stopAndHiddenOtherAnimation];
        [ARRecognitionView singleton].animationIndex = -1;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [[ARReportEndTimeHandle singleton] updateEndTime];
        [ARReportUpLoadManager uploadReport];
        [[ARReportEndTimeHandle singleton] restoration];
        self.doneBlock();
        [self removeFromSuperview];
    }else
    {
        [self removeFromSuperview];
        [MBProgressHUD showError:@"请输入正确的答案"];
    }
   
}
+(void)stopAR{
    [ARManager onPause];
    [[ARAudioManager singleton] stopPlay];
    [ARAudioManager singleton].InEasyAR_Working = NO;
    [ARAudioManager singleton].isRead = NO;
    [[ARRecognitionView singleton] stopAndHiddenOtherAnimation];
    [ARRecognitionView singleton].animationIndex = -1;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[ARReportEndTimeHandle singleton] updateEndTime];
    [ARReportUpLoadManager uploadReport];
    [[ARReportEndTimeHandle singleton] restoration];
}
-(void)close{
     [self removeFromSuperview];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
@end
