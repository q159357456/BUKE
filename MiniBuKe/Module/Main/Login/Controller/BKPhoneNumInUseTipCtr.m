//
//  BKPhoneNumInUseTipCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKPhoneNumInUseTipCtr.h"
#import "BKPhoneUseTipView.h"

@interface BKPhoneNumInUseTipCtr ()

@property(nonatomic, strong) BKPhoneUseTipView *tipView;

@end

@implementation BKPhoneNumInUseTipCtr

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
    
    self.tipView = [[BKPhoneUseTipView alloc]init];
    __weak typeof(self) weakSelf = self;
    
    [self.tipView setOkBtnClick:^{
        if (weakSelf.tryLoginAgainClick) {
            weakSelf.tryLoginAgainClick();
        }
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
