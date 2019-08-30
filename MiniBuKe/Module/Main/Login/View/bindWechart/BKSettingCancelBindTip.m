//
//  BKSettingCancelBindTip.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKSettingCancelBindTip.h"
@interface BKSettingCancelBindTip()

@property (nonatomic ,weak) IBOutlet UILabel *title;
@property (nonatomic ,weak) IBOutlet UILabel *subtitle;
@property (nonatomic ,weak) IBOutlet UIButton *leftBtn;
@property (nonatomic ,weak) IBOutlet UIButton *rightBtn;
@property (nonatomic ,weak) IBOutlet NSLayoutConstraint *offest;
@property (nonatomic ,weak) IBOutlet UIButton *bottomBtn;

@end
@implementation BKSettingCancelBindTip

- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKSettingCancelBindTip" owner:nil options:nil] lastObject];
        self.frame = CGRectMake(0, 0, 300, 144+20);
    }
    return self;
}
- (void)setTitle:(NSString*)titleStr andsubTitle:(NSString*)subTitle andLeftBtntitel:(NSString*)leftTitle andRightBtnTitle:(NSString*)rightTitle{
    if (titleStr.length) {
        self.title.text = titleStr;
        self.offest.constant = 30.f;
    }else{
        self.title.text = @"";
//        self.offest.constant = 40.f;
        self.frame = CGRectMake(0, 0, 300, 144);
    }
    if (subTitle.length) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:subTitle];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [paragraphStyle setLineSpacing:5];
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [subTitle length])];
        self.subtitle.attributedText = str;
    }else{
        self.subtitle.text = @"";
    }
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    
    if (!rightTitle.length) {
        [self.bottomBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.bottomBtn.hidden = NO;
    }else{
        self.bottomBtn.hidden = YES;
    }
    [self layoutIfNeeded];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 24.f;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
}

- (IBAction)leftbtnClick:(id)sender{
    if (_leftBtnClick) {
        _leftBtnClick();
    }
}
- (IBAction)rightbtnClick:(id)sender{
    if (_rightBtnClick) {
        _rightBtnClick();
    }
}
- (IBAction)bottomBtnClick:(id)sender{
    if (_leftBtnClick) {
        _leftBtnClick();
    }
}
@end
