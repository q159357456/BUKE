//
//  BKHomePopUpTipCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKHomePopUpTipCtr.h"
#import "BKHomePopView.h"

@interface BKHomePopUpTipCtr ()
@property (nonatomic, strong) BKHomePopView *tipView;
@property (nonatomic, strong) UIImageView *cancelImage;

@end

@implementation BKHomePopUpTipCtr

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
    
}
/**设置tip*/
-(void)showWithTitle:(NSString*)titleStr andsubTitle:(NSString*)subTitle andBtntitel:(NSString*)btnTitle andContent:(NSString*)content andImageName:(NSString*)imageName andIsTap:(BOOL)istap andIsFullPic:(BOOL)isFullPic AndBtnAction:(void(^)(void))BtnAction{
    
    if (istap) {
        UIView *tapView = [[UIView alloc]initWithFrame:self.view.frame];
        tapView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tapView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissCtr)];
        [tapView addGestureRecognizer:singleTap];
    }
    self.tipView = [[BKHomePopView alloc]init];
    [self.tipView setUpTitle:titleStr andsubTitle:subTitle andBtntitel:btnTitle andImageName:imageName andContent:content andIsFullPic:isFullPic];
    self.tipView.center = self.view.center;
    [self.tipView setBtnClick:^{
        return BtnAction();
    }];
    [self.view addSubview:self.tipView];
    if (istap) {
        self.cancelImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-22.f*2, (SCREEN_HEIGHT-(360/300.0)*(300/375.0)*SCREEN_WIDTH)*0.5-22.f, 22.f, 22.f)];
        self.cancelImage.image = [UIImage imageNamed:@"home_tipCancel_icon"];
        [self.view addSubview:self.cancelImage];
    }
}

- (void)dissMissCtr{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self.tipView removeFromSuperview];
        [self.cancelImage removeFromSuperview];
    }completion:^(BOOL finished) {
        self.cancelImage = nil;
        [self dismissViewControllerAnimated:NO completion:^{
        }];
        
    }];
    
}

/**弹出提示*/
-(void)startShowTipWithController:(UIViewController*)controller{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [controller presentViewController:self animated:NO completion:^{
        [UIView animateWithDuration:0.25 animations:^{
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        }];
    }];
}


@end
