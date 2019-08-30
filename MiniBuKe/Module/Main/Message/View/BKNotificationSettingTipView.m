//
//  BKNotificationSettingTipView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKNotificationSettingTipView.h"

@implementation BKNotificationSettingTipView

- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKNotificationSettingTipView" owner:nil options:nil] lastObject];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH,44);
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (IBAction)CloseBtnAction:(id)sender{
    if (self.CloseBtnClick) {
        self.CloseBtnClick();
    }
}
- (IBAction)ToOpenBtnAction:(id)sender{
    if (self.OpenBtnClick) {
        self.OpenBtnClick();
    }
}

@end
