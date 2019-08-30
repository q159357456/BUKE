//
//  ShareChooseView.m
//  MiniBuKe
//
//  Created by chenheng on 2019/7/23.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "ShareChooseView.h"
#import "BKMyBtton.h"
#import "ShareMinProj.h"
#define ShareViewHeight SCALE(141)
@interface ShareChooseView()
@property(nonatomic,strong)UIView *shareView;
@property(nonatomic,copy)void(^ShareChooseBcak)(NSInteger index);
@end

@implementation ShareChooseView
+(instancetype)shareChooseCallBack:(void(^)(NSInteger index))callBack{
    ShareChooseView * view = [[ShareChooseView alloc]init];
    view.ShareChooseBcak = callBack;
    [APP_DELEGATE.window addSubview:view];
    [UIView animateWithDuration:0.3 animations:^{
        view.shareView.frame = CGRectMake(0, SCREEN_HEIGHT-ShareViewHeight-45, SCREEN_WIDTH , ShareViewHeight+45);
    } completion:^(BOOL finished) {
        
    }];
    return view;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = A_COLOR_STRING(0x2F2F2F, 0.7);
        [self addSubview:self.shareView];
        
        
        
    }
    return self;
}
-(UIView *)shareView
{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,ShareViewHeight+45)];
        _shareView.backgroundColor = COLOR_STRING(@"#F8F8F8");
        NSArray *titleArray = @[@"微信",@"生成海报"];
        NSArray *imageArray = @[@"wechat_icon_c",@"poster"];
        CGFloat width = SCREEN_WIDTH/2;
        BKMyBtton *btn1 = [[BKMyBtton alloc]initWithFrame:CGRectMake(0, 0, width, ShareViewHeight) ImageFrame:CGRectMake(SCALE(85), SCALE(30), SCALE(60), SCALE(60)) TitleFrame:CGRectMake(SCALE(83), SCALE(99), SCALE(64), 13)];
        
        btn1.titleImage.image = [UIImage imageNamed:imageArray[0]];
        btn1.contentText.text = titleArray[0];
        btn1.contentText.font = [UIFont systemFontOfSize:SCALE(12)];
        [btn1 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag = 1;
        [_shareView addSubview:btn1];
        
        BKMyBtton *btn2 = [[BKMyBtton alloc]initWithFrame:CGRectMake(width, 0, width, ShareViewHeight) ImageFrame:CGRectMake(width- SCALE(85)-SCALE(60), SCALE(30), SCALE(60), SCALE(60)) TitleFrame:CGRectMake(width-SCALE(83)-SCALE(64), SCALE(99), SCALE(64), 13)];
        btn2.titleImage.image = [UIImage imageNamed:imageArray[1]];
        btn2.contentText.text = titleArray[1];
        btn2.contentText.font = [UIFont systemFontOfSize:SCALE(12)];
        [btn2 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        btn2.tag = 2;
        [_shareView addSubview:btn2];
        
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, ShareViewHeight, SCREEN_WIDTH, 45)];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"取消" forState:UIControlStateNormal];
//        button.backgroundColor = COLOR_STRING(@"#F7F9FB");
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:button];
        [self cornerRadius:_shareView];
        
    }
    return _shareView;
}
-(void)onClick:(UIButton*)btn{
    
    [self hidden];

    if (btn.tag == 1) {
    
        if (self.ShareChooseBcak) {
            self.ShareChooseBcak(0);
        }
    }else
    {
        if (self.ShareChooseBcak) {
            self.ShareChooseBcak(1);
        }
    }
    
    
}
-(void)show
{
    [APP_DELEGATE.window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT-ShareViewHeight-45, SCREEN_WIDTH , ShareViewHeight+45);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ShareViewHeight+45);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hidden];
}
-(void)cornerRadius:(UIView*)view{
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(SCALE(14), SCALE(14))];
    CAShapeLayer * shap = [CAShapeLayer layer];
    shap.frame = view.bounds;
    shap.path = path.CGPath;
    //    shap.backgroundColor = [UIColor redColor].CGColor;
    view.layer.mask = shap;
    view.layer.masksToBounds = YES;
    
}
@end
