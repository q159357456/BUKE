//
//  BKPhoneUseTipView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKPhoneUseTipView.h"

@interface BKPhoneUseTipView()

@property (nonatomic, weak) IBOutlet UIButton *btn;

@end

@implementation BKPhoneUseTipView

- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKPhoneUseTipView" owner:nil options:nil] lastObject];
        self.frame = CGRectMake(0, 0, 300, 144);
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 24.f;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
}

- (IBAction)btnClick:(id)sender{
    if (_okBtnClick) {
        _okBtnClick();
    }
}

@end
