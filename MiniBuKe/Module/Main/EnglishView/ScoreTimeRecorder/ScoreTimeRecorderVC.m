//
//  ScoreTimeRecorderVC.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/15.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ScoreTimeRecorderVC.h"
#import "English_Header.h"
#import "TimeStyleChooseView.h"
#import "ScoreBottomView.h"
#import "ChooseAgeClickView.h"
#import "ChangeScoreTimeView.h"
#import "ScoreTimeBaseController.h"
@interface ScoreTimeRecorderVC ()<UIScrollViewDelegate>
{
    NSInteger _selectController;
}
@property(nonatomic,strong)TimeStyleChooseView *timeStyleChooseView;
@property(nonatomic,strong)ChooseAgeClickView *chooseModeView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)ChangeScoreTimeView *changeModeView;
@property(nonatomic,strong)ScoreTimeBaseController *day_ViewController;
@property(nonatomic,strong)ScoreTimeBaseController *month_ViewController;
@property(nonatomic,strong)ScoreTimeBaseController *week_ViewController;
@property(nonatomic,strong)ScoreTimeBaseController *total_ViewController;
//
@property(nonatomic,strong)ScoreTimeBaseController *T_day_ViewController;
@property(nonatomic,strong)ScoreTimeBaseController *T_month_ViewController;
@property(nonatomic,strong)ScoreTimeBaseController *T_week_ViewController;
@property(nonatomic,strong)ScoreTimeBaseController *T_total_ViewController;
@property(nonatomic,strong)UIScrollView *scroView;
@property(nonatomic,assign)ScoreTimeEnum  scoreTimeEnum;
//@property(nonatomic,assign)ScoreTimeEnum scoreTimeEnum;
@end

@implementation ScoreTimeRecorderVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.timeStyleChooseView];
    [self addChildViewController:self.day_ViewController];
    [self.scroView addSubview:self.day_ViewController.view];
    self.scoreTimeEnum = Score_Style;
    self.day_ViewController.drawingView.scoreTimeEnum = self.scoreTimeEnum;
    self.day_ViewController.drawingView.dateStyleEnum = Day_Style;
    _selectController = 0;
     UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:(@selector(panScro:))];
    [self.view addGestureRecognizer:pan];
    [self.view addSubview:self.scroView];
}

#pragma mark - 懒加载

                                                                                             
-(UIScrollView *)scroView
{
    if (!_scroView) {
        _scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeStyleChooseView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.timeStyleChooseView.frame))];
        _scroView.contentSize = CGSizeMake(SCREEN_WIDTH*4, _scroView.bounds.size.height);
        _scroView.pagingEnabled = YES;
        _scroView.bounces = NO;
        _scroView.delegate = self;
        _scroView.scrollEnabled  =NO;
    }
    return _scroView;
}
-(ScoreTimeBaseController *)day_ViewController
{
    if (!_day_ViewController) {
        _day_ViewController = [[ScoreTimeBaseController alloc]init];
        _day_ViewController.view.frame = self.scroView.bounds;
        
    }
    return _day_ViewController;
}
-(ScoreTimeBaseController *)week_ViewController
{
    if (!_week_ViewController) {
        _week_ViewController = [[ScoreTimeBaseController alloc]init];
        _week_ViewController.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scroView.bounds.size.height);
        
    }
    return _week_ViewController;
}
-(ScoreTimeBaseController *)month_ViewController
{
    if (!_month_ViewController) {
        _month_ViewController = [[ScoreTimeBaseController alloc]init];
        _month_ViewController.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, self.scroView.bounds.size.height);
        
    }
    return _month_ViewController;
}
-(ScoreTimeBaseController *)total_ViewController
{
    if (!_total_ViewController) {
        _total_ViewController = [[ScoreTimeBaseController alloc]init];
        _total_ViewController.view.frame = CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, self.scroView.bounds.size.height);
      
    }
    return _total_ViewController;
}


-(ScoreTimeBaseController *)T_day_ViewController
{
    if (!_T_day_ViewController) {
        _T_day_ViewController = [[ScoreTimeBaseController alloc]init];
        _T_day_ViewController.view.frame = self.scroView.bounds;
        
    }
    return _T_day_ViewController;
}
-(ScoreTimeBaseController *)T_week_ViewController
{
    if (!_T_week_ViewController) {
        _T_week_ViewController = [[ScoreTimeBaseController alloc]init];
        _T_week_ViewController.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scroView.bounds.size.height);
        
    }
    return _T_week_ViewController;
}
-(ScoreTimeBaseController *)T_month_ViewController
{
    if (!_T_month_ViewController) {
        _T_month_ViewController = [[ScoreTimeBaseController alloc]init];
        _T_month_ViewController.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, self.scroView.bounds.size.height);
        
    }
    return _T_month_ViewController;
}
-(ScoreTimeBaseController *)T_total_ViewController
{
    if (!_T_total_ViewController) {
        _T_total_ViewController = [[ScoreTimeBaseController alloc]init];
        _T_total_ViewController.view.frame = CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, self.scroView.bounds.size.height);
        
    }
    return _T_total_ViewController;
}

-(UIView *)changeModeView
{
    if (!_changeModeView) {
        _changeModeView = [[ChangeScoreTimeView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT -50)];
    }
    return _changeModeView;
}
-(ChooseAgeClickView *)chooseModeView
{
    if (!_chooseModeView) {
        _chooseModeView = [ChooseAgeClickView get_chooseage_viewTitle:@"学习成绩" Font:[UIFont boldSystemFontOfSize:15] Frame:CGRectZero];
        _chooseModeView.positionState = Top_State;
        
    }
    return _chooseModeView;
}
-(UIView *)topView
{
    if (!_topView) {
        CGFloat statuHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat navHeight = 44.f + statuHeight;
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, navHeight)];
        _topView.backgroundColor = COLOR_STRING(@"#F0F3F7");
        [self.view addSubview:_topView];
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, statuHeight==44?30:20, 40, 40)];
        
        [backButton setImage:[UIImage imageNamed:@"identity_navibar_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:backButton];
        self.chooseModeView.center = CGPointMake(self.topView.center.x, self.topView.center.y+5);
        self.chooseModeView.layer.borderColor = [UIColor clearColor].CGColor;
        [_topView addSubview:self.chooseModeView];
    }
    return _topView;
}

-(TimeStyleChooseView *)timeStyleChooseView
{
    if (!_timeStyleChooseView) {
        _timeStyleChooseView = [[TimeStyleChooseView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, 50)];
    }
    return _timeStyleChooseView;
}


#pragma mark - action
-(void)backButtonClick:(UIButton*)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)panScro:(UIPanGestureRecognizer*)pan{
    
   
   
   
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self commitTranslation:[pan velocityInView:pan.view]];
    }
   
    
}
- (void)commitTranslation:(CGPoint)translation
{
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    // 设置滑动有效距离
    if (MAX(absX, absY) < 10)
        return;

    if (absX > absY ) {
        
        if (translation.x<0) {
            
     
            if (_selectController==3) {
                return;
            }
            _selectController++;
            [self.scroView setContentOffset:CGPointMake(_selectController *SCREEN_WIDTH, 0) animated:YES];
            [self.timeStyleChooseView moveTo:_selectController];
            [self addChild:_selectController];
           
        }else{
            
            //向右滑动
            if (_selectController==0) {
                return;
            }
            _selectController -- ;
             [self.scroView setContentOffset:CGPointMake(_selectController *SCREEN_WIDTH, 0) animated:YES];
            [self.timeStyleChooseView moveTo:_selectController];
            [self addChild:_selectController];
        }
        
    } else if (absY > absX) {
        if (translation.y<0) {
            
        
            
        }else{
            
            //向下滑动

        }
    }
    
    
}

//uiresponder
-(void)eventName:(NSString *)eventname Params:(id)params
{
    /***********************************************************/
    if ([eventname isEqualToString:ChooseAgeClickView_Event])
    {
        
        if ([self.view.subviews containsObject:self.changeModeView])
        {
           
            [self.changeModeView removeFromSuperview];
        }else
        {
            [self.view addSubview:self.changeModeView];
        }
    }
    
    /***********************************************************/
    else if ([eventname isEqualToString:TimeStyleChooseView_Event])
    {
        
        
        NSInteger para = [params integerValue];
        [self.scroView setContentOffset:CGPointMake(SCREEN_WIDTH*para, 0) animated:YES];
        _selectController = para;
        [self addChild:para];
     
        
        
    }
    
    /***********************************************************/
    else if ([eventname isEqualToString:ChangeScoreTimeView_Event])
    {
         NSInteger para = [params integerValue];
         if (para == 0)
         {
             //选中成绩
             [self.timeStyleChooseView rese];
             self.scroView.contentOffset = CGPointMake(0, 0);
             [self.chooseModeView packup];
             [self.chooseModeView remakeConstraintsTitle:@"学习成绩" PositionState:Top_State];
             self.scoreTimeEnum = Score_Style;
             [self removeT_Childs];
             [self addChildViewController:self.day_ViewController];
             [self.scroView addSubview:self.day_ViewController.view];
             self.day_ViewController.drawingView.scoreTimeEnum = Score_Style;
             self.day_ViewController.drawingView.dateStyleEnum = Day_Style;
             
            
         }else if (para == 1)
         {
             //选中时长
             [self.timeStyleChooseView rese];
             self.scroView.contentOffset = CGPointMake(0, 0);
             [self.chooseModeView packup];
             [self.chooseModeView remakeConstraintsTitle:@"学习时长" PositionState:Top_State];
             self.scoreTimeEnum = Time_Style;
             [self removeChilds];
             [self addChildViewController:self.T_day_ViewController];
             [self.scroView addSubview:self.T_day_ViewController.view];
             self.T_day_ViewController.drawingView.scoreTimeEnum = Time_Style;
             self.T_day_ViewController.drawingView.dateStyleEnum = Day_Style;
             
         }else
         {
             
             //未选
             [self.chooseModeView packup];
         }
        
    }
    
}


#pragma mark - scrollViewDidEndDecelerating
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    [self.timeStyleChooseView moveTo:point.x/SCREEN_WIDTH];
    [self addChild:point.x/SCREEN_WIDTH];
    
}
#pragma mark - private
-(void)addChild:(NSInteger)index{
    
    switch (index) {
        case 0:
        {
            if (self.scoreTimeEnum == Score_Style)
            {
                if (![self.childViewControllers containsObject:self.day_ViewController]) {
                    [self addChildViewController:self.day_ViewController];
                    [self.scroView addSubview:self.day_ViewController.view];
                    self.day_ViewController.drawingView.scoreTimeEnum = self.scoreTimeEnum;
                    self.day_ViewController.drawingView.dateStyleEnum = Day_Style;
                    
                }
            }else
            {
                if (![self.childViewControllers containsObject:self.T_day_ViewController]) {
                    [self addChildViewController:self.T_day_ViewController];
                    [self.scroView addSubview:self.T_day_ViewController.view];
                    self.T_day_ViewController.drawingView.scoreTimeEnum = self.scoreTimeEnum;
                    self.T_day_ViewController.drawingView.dateStyleEnum = Day_Style;
                    
                }
            }
           
            
        }
            break;
        case 1:
        {
            if (self.scoreTimeEnum == Score_Style) {
                if (![self.childViewControllers containsObject:self.week_ViewController]) {
                    [self addChildViewController:self.week_ViewController];
                    [self.scroView addSubview:self.week_ViewController.view];
                    self.week_ViewController.drawingView.scoreTimeEnum = self.scoreTimeEnum;
                    self.week_ViewController.drawingView.dateStyleEnum = WeekStyle;
                    
                }
            }else
            {
                if (![self.childViewControllers containsObject:self.T_week_ViewController]) {
                    [self addChildViewController:self.T_week_ViewController];
                    [self.scroView addSubview:self.T_week_ViewController.view];
                    self.T_week_ViewController.drawingView.scoreTimeEnum = self.scoreTimeEnum;
                    self.T_week_ViewController.drawingView.dateStyleEnum = WeekStyle;
                    
                }
                
            }
           
           
        }
            break;
        case 2:
        {
            if (self.scoreTimeEnum == Score_Style) {
                
                if (![self.childViewControllers containsObject:self.month_ViewController]) {
                    [self addChildViewController:self.month_ViewController];
                    [self.scroView addSubview:self.month_ViewController.view];
                    self.month_ViewController.drawingView.scoreTimeEnum = self.scoreTimeEnum;
                    self.month_ViewController.drawingView.dateStyleEnum = Month_Style;
                }
            }else
            {
                if (![self.childViewControllers containsObject:self.T_month_ViewController]) {
                    [self addChildViewController:self.T_month_ViewController];
                    [self.scroView addSubview:self.T_month_ViewController.view];
                    self.T_month_ViewController.drawingView.scoreTimeEnum = self.scoreTimeEnum;
                    self.T_month_ViewController.drawingView.dateStyleEnum = Month_Style;
                }
                
            }
            
            
        }
            break;
        case 3:
        {
            if (self.scoreTimeEnum == Score_Style) {
                if (![self.childViewControllers containsObject:self.total_ViewController])
                {
                    [self addChildViewController:self.total_ViewController];
                    [self.scroView addSubview:self.total_ViewController.view];
                    self.total_ViewController.drawingView.scoreTimeEnum = self.scoreTimeEnum;
                    self.total_ViewController.drawingView.dateStyleEnum = TotalStyle;
                    
                }
            }else
            {
                if (![self.childViewControllers containsObject:self.T_total_ViewController])
                {
                    [self addChildViewController:self.T_total_ViewController];
                    [self.scroView addSubview:self.T_total_ViewController.view];
                    self.T_total_ViewController.drawingView.scoreTimeEnum = self.scoreTimeEnum;
                    self.T_total_ViewController.drawingView.dateStyleEnum = TotalStyle;
                    
                }
            }
           
            
        }
            break;
            
    }

}

-(void)removeChilds{
    if ([self.childViewControllers containsObject:self.day_ViewController]) {
        [self.day_ViewController removeFromParentViewController];
        [self.day_ViewController.view removeFromSuperview];
    }
    
    if ([self.childViewControllers containsObject:self.week_ViewController]) {
        [self.week_ViewController removeFromParentViewController];
        [self.week_ViewController.view removeFromSuperview];
    }
    if ([self.childViewControllers containsObject:self.month_ViewController]) {
        [self.month_ViewController removeFromParentViewController];
        [self.month_ViewController.view removeFromSuperview];
    }
    
    if ([self.childViewControllers containsObject:self.total_ViewController]) {
        [self.total_ViewController removeFromParentViewController];
        [self.total_ViewController.view removeFromSuperview];
    }

    
    
}

-(void)removeT_Childs{
    
    if ([self.childViewControllers containsObject:self.T_day_ViewController]) {
        [self.T_day_ViewController removeFromParentViewController];
        [self.T_day_ViewController.view removeFromSuperview];
    }
    
    if ([self.childViewControllers containsObject:self.T_week_ViewController]) {
        [self.T_week_ViewController removeFromParentViewController];
        [self.T_week_ViewController.view removeFromSuperview];
    }
    if ([self.childViewControllers containsObject:self.T_month_ViewController]) {
        [self.T_month_ViewController removeFromParentViewController];
        [self.T_month_ViewController.view removeFromSuperview];
    }
    
    if ([self.childViewControllers containsObject:self.T_total_ViewController]) {
        [self.T_total_ViewController removeFromParentViewController];
        [self.T_total_ViewController.view removeFromSuperview];
    }
}
@end
