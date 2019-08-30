//
//  TalkNotificationNav.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TalkNotificationNav.h"
#import "UIResponder+Event.h"
@interface TalkNotificationNav()
{
    NSInteger slectIndex;
}
@property(nonatomic,strong)UIView *notifactionView;
@property(nonatomic,strong)UIView *talkView;
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;
@end
@implementation TalkNotificationNav

-(instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kNavbarH);
        [self initSubview];
    }
    return self;
}
-(UIView *)notifactionView
{
    if (!_notifactionView) {
        _notifactionView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-SCALE(17), kNavbarH-30, 8, 8)];
        _notifactionView.backgroundColor =COLOR_STRING(@"#F04348");
        _notifactionView.layer.cornerRadius = 4;
        _notifactionView.layer.masksToBounds = YES;
        _notifactionView.hidden = YES;
    }
    return _notifactionView;
}
-(UIView *)talkView
{
    if (!_talkView) {
        _talkView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+SCALE(47), kNavbarH-30, 8, 8)];
        _talkView.backgroundColor =COLOR_STRING(@"#F04348");
        _talkView.layer.cornerRadius = 4;
        _talkView.layer.masksToBounds = YES;
        _talkView.hidden = YES;
    }
    return _talkView;
}
-(void)initSubview{
    
           UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, kStatusBarH==44?39:23 , 40, 40)];
           [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
           [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
           [self addSubview:backButton];
    
            UIButton *btn1 =[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, kNavbarH-30-4, SCREEN_WIDTH/6, 30)];
            UIButton *btn2 =[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, kNavbarH-30-4, SCREEN_WIDTH/6, 30)];
            UIView *linview =[[UIView alloc]initWithFrame:CGRectMake(0, 0,40, 4)];
             linview.center = CGPointMake(btn1.center.x, kNavbarH-2.5);
            linview.layer.cornerRadius =2;
            linview.backgroundColor = COLOR_STRING(@"#54BB51");
            UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, kNavbarH - 1, SCREEN_WIDTH, 1)];
            UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
            top.backgroundColor = [UIColor whiteColor];
            bottom.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
            
            [self addSubview:btn1];
            [self addSubview:btn2];
            [self addSubview:linview];
            [self addSubview:bottom];
            [self addSubview:top];
            [self addSubview:self.talkView];
            [self addSubview:self.notifactionView];
    
            
            [btn1 setTitle:@"消息" forState:UIControlStateNormal];
            [btn2 setTitle:@"说说" forState:UIControlStateNormal];
   
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [btn1 setTitleColor:COLOR_STRING(@"#999999") forState:UIControlStateNormal];
            [btn2 setTitleColor:COLOR_STRING(@"#999999") forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:SCALE(16) weight:UIFontWeightBold];
            btn2.titleLabel.font = [UIFont systemFontOfSize:SCALE(16) weight:UIFontWeightBold];
            [btn1 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
            [btn2 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
            btn1.tag =1;
            btn2.tag =2;
            btn1.selected = YES;
            self.button1 = btn1;
            self.button2 = btn2;
            self.linview = linview;
            slectIndex =1;
            btn1.selected = YES;//        [
            
  
}

-(void)comme{
    
    
    
}
-(void)change:(UIButton*)btn{
    
    if (btn.selected) {
        
        return;
    }
    
    btn.selected = YES;
    if (slectIndex) {
        UIButton *butt = [self viewWithTag:slectIndex];
        butt.selected = NO;
        
    }
//    [UIView animateWithDuration:3 animations:^{
//       self.linview.center = CGPointMake(btn.center.x, kNavbarH-2);
//    }];
    slectIndex = btn.tag;
    
    [self eventName:TalkNotificationNav_Event Params:[NSNumber numberWithInteger:btn.tag -1]];
    
    
    
    
    
}


-(void)animationTo:(NSInteger)index{
    //    NSLog(@"index=====>%ld",index);
    UIButton *butt = [self viewWithTag:slectIndex];
    butt.selected = NO;
    UIButton *butt_s = [self viewWithTag:index+1];
    butt_s.selected = YES;
    self.linview.center = CGPointMake(butt_s.center.x, kNavbarH-2.5);
    slectIndex =index+1;
    
}
-(void)backButtonClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:PushBackClearRedPoint object:nil];
    [APP_DELEGATE.navigationController popViewControllerAnimated:YES];
}

-(void)setNotifactionBadge:(BOOL)hidden
{
    self.notifactionView.hidden = hidden;
}
-(void)setTalkBadge:(BOOL)hidden
{
    
    self.talkView.hidden = hidden;
}
-(BOOL)GetTalkBadgeIsHide{
    return self.talkView.hidden;
}

-(void)animationWithOffset:(CGFloat)offset
{
    CGFloat temp = self.button2.center.x - self.button1.center.x;
    CGFloat bili = temp/SCREEN_WIDTH;
    CGFloat  translationX = bili * offset;
    
    if (fmodf(offset, SCREEN_WIDTH) == 0) {
        NSInteger index = offset/SCREEN_WIDTH;
        if (index==0) {
            self.button1.selected=YES;
            self.button2.selected=NO;
        }else
        {
            self.button1.selected=NO;
            self.button2.selected=YES;
        }
    }
    
    CGFloat width = fabs(translationX - temp/2);
    CGFloat scale = 30*2/temp;
    self.linview.frame = CGRectMake(self.linview.frame.origin.x, self.linview.frame.origin.y,70-width*scale, self.linview.frame.size.height);
    self.linview.center = CGPointMake(self.button1.center.x + translationX, kNavbarH-2);
    
}
@end
