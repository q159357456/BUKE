//
//  BKWeChartBindUseTipCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKWeChartBindUseTipCtr.h"
#import "BKWeChartUseTipView.h"
@interface BKWeChartBindUseTipCtr ()

@property(nonatomic, strong) BKWeChartUseTipView *tipView;

@end

@implementation BKWeChartBindUseTipCtr
- (instancetype)init{
    if (self = [super init]) {
        self.view.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}
- (void)setUI{
    
    self.tipView = [[BKWeChartUseTipView alloc]init];
    __weak typeof(self) weakSelf = self;
    
    [self.tipView setOkBtnClick:^{
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
- (void)setTitleWithNumber:(NSString*)number{
    [self.tipView setTitleWithNumber:number];
}

-(void)startShowTipWithController:(UIViewController*)controller{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [controller presentViewController:self animated:NO completion:^{
        [UIView animateWithDuration:0.25 animations:^{
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        }];
    }];
}
@end
