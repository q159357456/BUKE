//
//  BKTixianWeChartTipCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKTixianWeChartTipCtr.h"

@interface BKTixianWeChartTipCtr ()

@end

@implementation BKTixianWeChartTipCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *tapView = [[UIView alloc]initWithFrame:self.view.frame];
    tapView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tapView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissCtr)];
    [tapView addGestureRecognizer:singleTap];
    
    [self setUI];
}
- (void)setUI{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    self.tipView = [[BKDepsitTipWeChartView alloc]init];
    __weak typeof(self) weakSelf = self;
    [self.tipView setClickDoneBtn:^{
        [weakSelf dissMissCtr];
        if (weakSelf.ClickDoneBtn) {
            weakSelf.ClickDoneBtn();
        }
    }];
    self.tipView.center = self.view.center;
    [self.view addSubview:self.tipView];
    
}

- (void)dissMissCtr{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.tipView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 233);
    }completion:^(BOOL finished) {
        [self.tipView removeFromSuperview];
        [self dismissViewControllerAnimated:NO completion:^{
        }];
        
    }];
    
}
- (void)setUIWithImageUrl:(NSString*)url andNameStr:(NSString*)nameStr andTitleStr:(NSString*)titleStr andBtnStr:(NSString*)btnStr{
    [self.tipView setUIWithImageUrl:url andNameStr:nameStr andTitleStr:titleStr andBtnStr:btnStr];
}

@end
