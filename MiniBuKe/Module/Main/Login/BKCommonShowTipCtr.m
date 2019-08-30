//
//  BKCommonShowTipCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/6.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCommonShowTipCtr.h"
#import "BKSettingCancelBindTip.h"

@interface BKCommonShowTipCtr ()

@property(nonatomic, strong) BKSettingCancelBindTip *tipView;

@end

@implementation BKCommonShowTipCtr

- (instancetype)init{
    if (self = [super init]) {
        self.view.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

-(void)showWithTitle:(NSString*)titleStr andsubTitle:(NSString*)subTitle andLeftBtntitel:(NSString*)leftTitle andRightBtnTitle:(NSString*)rightTitle andIsTap:(BOOL)istap AndLeftBtnAction:(void(^)(void))LeftAction AndRightBtnAction:(void(^)(void))rightAction{
    if (istap) {
        UIView *tapView = [[UIView alloc]initWithFrame:self.view.frame];
        tapView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tapView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissCtr)];
        [tapView addGestureRecognizer:singleTap];
    }
    
    self.tipView = [[BKSettingCancelBindTip alloc]init];
    [self.tipView setTitle:titleStr andsubTitle:subTitle andLeftBtntitel:leftTitle andRightBtnTitle:rightTitle];
    __weak typeof(self) weakSelf = self;
    [self.tipView setLeftBtnClick:^{
        [weakSelf dissMissCtr];
        return LeftAction();
    }];
    [self.tipView setRightBtnClick:^{
        [weakSelf dissMissCtr];
        return rightAction();
    }];
    self.tipView.center = self.view.center;
    [self.view addSubview:self.tipView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)startShowTip{
    
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

-(void)startShowTipWithController:(UIViewController*)controller{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [controller presentViewController:self animated:NO completion:^{
        [UIView animateWithDuration:0.25 animations:^{
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        }];
    }];
}

@end
