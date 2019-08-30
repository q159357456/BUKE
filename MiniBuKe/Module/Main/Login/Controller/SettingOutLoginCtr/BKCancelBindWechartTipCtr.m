//
//  BKCancelBindWechartTipCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCancelBindWechartTipCtr.h"
#import "BKSettingCancelBindTip.h"

@interface BKCancelBindWechartTipCtr ()

@property(nonatomic, strong) BKSettingCancelBindTip *tipView;

@end

@implementation BKCancelBindWechartTipCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}
- (void)setUI{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    self.tipView = [[BKSettingCancelBindTip alloc]init];
    __weak typeof(self) weakSelf = self;
    
    [self.tipView setLeftBtnClick:^{
        if (weakSelf.goCancelBindWeChart) {
            weakSelf.goCancelBindWeChart();
        }
        [weakSelf dissMissCtr];
    }];
    [self.tipView setRightBtnClick:^{
        [weakSelf dissMissCtr];
    }];
    
    self.tipView.center = self.view.center;
    [self.view addSubview:self.tipView];
}

- (void)dissMissCtr{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self.tipView removeFromSuperview];
    }completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:^{
    }];
        
    }];
    
}
@end
