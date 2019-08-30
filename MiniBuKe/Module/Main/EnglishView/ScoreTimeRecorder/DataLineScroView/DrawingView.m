//
//  DrawingView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "DrawingView.h"
#import "English_Header.h"
#import "TeachingResultService.h"
#import "ScoreTotalView.h"
#import "TiemTotalView.h"
#import "MyShapLayer.h"
static CGFloat trigon = 15;
@interface DrawingView ()<UIScrollViewDelegate>
{
    NSInteger _selectIndex;
}

@property(nonatomic,strong)DataLineScroView *dataScroView;
@property(nonatomic,strong)CAShapeLayer *trigonLayer;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)DataLineView *dataLineView;
@property(nonatomic,strong)DataColumnarView *dataColumnarView;
@property(nonatomic,strong)UILabel *timeLable;
@property(nonatomic,strong)ScoreTotalView *scoreTotalView;
@property(nonatomic,strong)TiemTotalView *tiemTotalView;
@property(nonatomic,strong)UIImageView *nodataImageView;
@end
@implementation DrawingView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_STRING(@"#F0F3F7");
        [self addSubview:self.timeLable];
        [self addSubview:self.dataScroView];
    }
    return self;
}
-(UIImageView *)nodataImageView
{
    if (!_nodataImageView) {
        _nodataImageView = [[UIImageView alloc]initWithFrame:self.bounds];
       
        
        _nodataImageView.image = [UIImage imageNamed:@"no_data_bg"];
    }
    return _nodataImageView;
}
-(CAShapeLayer *)trigonLayer
{
    if (!_trigonLayer) {
        _trigonLayer = [CAShapeLayer layer];
        CGFloat temp = colum + (with + colum)*2;
        _trigonLayer.frame = CGRectMake(temp+(with-trigon)/2,self.bounds.size.height - trigon, trigon, trigon);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPoint points[3];
        points[0]= CGPointMake(trigon/4, trigon);
        points[1]=CGPointMake(trigon/2, trigon - trigon*cosf(AngleToRadian(30))/2);
        points[2]=CGPointMake(trigon*3/4,trigon);
        CGPathAddLines(path, nil, points, 3);
        _trigonLayer.fillColor = [UIColor whiteColor].CGColor;
        _trigonLayer.path = path;
        CGPathRelease(path);
        
    }
    return _trigonLayer;
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)setDateStyleEnum:(DateStyleEnum)dateStyleEnum
{
    
    _dateStyleEnum = dateStyleEnum;
    if (self.scoreTimeEnum == Score_Style)
    {
       
        self.timeLable.hidden = YES;
    }else
    {
        self.timeLable.hidden = NO;
    }
    switch (dateStyleEnum) {
        case Day_Style:
        {
            [self get_teaching_result:self.scoreTimeEnum Time:_dateStyleEnum];

        }
            break;
            
        case WeekStyle:
        {
            [self get_teaching_result:self.scoreTimeEnum Time:_dateStyleEnum];
        }
            break;
        case Month_Style:
        {
            [self get_teaching_result:self.scoreTimeEnum Time:_dateStyleEnum];
        }
            break;
        case TotalStyle:
        {
            
            [self get_teaching_result:self.scoreTimeEnum Time:_dateStyleEnum];
        }
            break;
    }
    
}
#pragma mark - data
-(void)get_teaching_result:(NSInteger)type Time:(NSInteger)time{
    
    [MBProgressHUD showMessage:@""];
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"获取分类 ==> OnSuccess");
        TeachingResultService *service =(TeachingResultService * )httpInterface;
        [self.dataArray removeAllObjects];
        
        [self.dataArray addObjectsFromArray:service.dataArray];
        [MBProgressHUD hideHUD];
        
        [self changeState];
      
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"LoginService ==> OnError");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:description]; 
    };
    
    TeachingResultService *service = [[TeachingResultService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token Type:type Time:time];
    [service start];
    
}
-(void)changeState
{
    if (self.dataArray.count ==0) {
        [self addSubview:self.nodataImageView];
         UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
        lable.numberOfLines = 0;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        lable.text = @"暂无数据,\n快去体验机器人英语口语测评功能吧！";
        [self addSubview:lable];
        [self SelfDelegateChosen:nil];
        return;
    }
    [self SelfDelegateChosen:self.dataArray.lastObject];
    switch (self.scoreTimeEnum) {
        case Score_Style:
        {
            if (self.dateStyleEnum == TotalStyle)
            {
                if (self.dataArray.count) {
                    
                    TimeScore *model = self.dataArray.firstObject;
                    self.scoreTotalView.score = [NSString stringWithFormat:@"%@",model.score];
                    [self addSubview:self.scoreTotalView];
                }
            }else
            {
                _selectIndex = self.dataArray.count -1;
                self.timeLable.text =@"";
                if ([self.layer.sublayers containsObject:self.trigonLayer]) {
                    [self.trigonLayer removeFromSuperlayer];
                }
                if ([self.subviews containsObject:self.scoreTotalView]) {
                    [self.scoreTotalView removeFromSuperview];
                }
                if ([self.subviews containsObject:self.tiemTotalView]) {
                    [self.tiemTotalView removeFromSuperview];
                }
                
//                [self.dataColumnarView removeFromSuperview];
                self.dataLineView = [[DataLineView alloc]initWithFrame:CGRectMake(0, 0, P_TO_P_WITH*(self.dataArray.count - 1) + SCREEN_WIDTH, self.frame.size.height) Data:self.dataArray];
                self.dataScroView.contentSize = CGSizeMake(self.dataLineView.frame.size.width, self.dataScroView.bounds.size.height);
                 self.dataScroView.contentOffset = CGPointMake(self.dataLineView.frame.size.width - SCREEN_WIDTH, 0);
                [self.dataScroView addSubview:self.dataLineView];
//                [self setposition:self.dataScroView];

            }
        }
            break;
            
        case Time_Style:
        {
            if (self.dateStyleEnum == TotalStyle)
            {
                if (self.dataArray.count) {
                    TimeScore *model = self.dataArray.firstObject;
                    self.tiemTotalView.time = [NSString stringWithFormat:@"%@",model.score];
                }
                [self addSubview:self.tiemTotalView];
                
            }else
            {
                
                if ([self.subviews containsObject:self.scoreTotalView]) {
                    [self.scoreTotalView removeFromSuperview];
                }
                if ([self.subviews containsObject:self.tiemTotalView]) {
                    [self.tiemTotalView removeFromSuperview];
                }
             
               self.dataColumnarView = [[DataColumnarView alloc]initWithFrame:CGRectMake(0, 0, (with + colum)*(self.dataArray.count - 1) + SCREEN_WIDTH, self.frame.size.height) Data:self.dataArray];
//                [self.dataLineView removeFromSuperview];
                if (self.dateStyleEnum == Day_Style) {
                    self.timeLable.text =@"   学习时长(分钟)";
                    self.dataColumnarView.isMinute = YES;
                }else if (self.dateStyleEnum == WeekStyle)
                {
                    self.timeLable.text =@"   学习时长(小时)";
                    self.dataColumnarView.isMinute = NO;
                }else if (self.dateStyleEnum == Month_Style){
                    
                    self.timeLable.text =@"   学习时长(小时)";
                    self.dataColumnarView.isMinute = NO;
                }
                
               [self.dataScroView addSubview:self.dataColumnarView];
               self.dataScroView.contentSize = CGSizeMake(self.dataColumnarView.frame.size.width, self.dataScroView.bounds.size.height);
                self.dataScroView.contentOffset = CGPointMake((with + colum)*(self.dataArray.count - 1), 0);
                [self.layer addSublayer:self.trigonLayer];
                _selectIndex = self.dataArray.count-1;
//                [self setposition:self.dataScroView];
               

            }
        }
            break;
    }
    
}
#pragma mark - 懒加载
-(UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 35)];
        _timeLable.text =@"   学习时长(分钟)";
        _timeLable.backgroundColor = COLOR_STRING(@"#F0F3F7");
        _timeLable.textColor = COLOR_STRING(@"#999999");
        _timeLable.font = [UIFont systemFontOfSize:11];
    }
    return _timeLable;
}
-(DataLineScroView *)dataScroView
{
    if (!_dataScroView) {
        _dataScroView = [[DataLineScroView alloc]initWithFrame:CGRectMake(0, 35, self.frame.size.width, self.bounds.size.height -35)];
        _dataScroView.showsHorizontalScrollIndicator = NO;
        _dataScroView.delegate = self;
        _dataScroView.bounces = NO;
    }
    return _dataScroView;
}
-(ScoreTotalView *)scoreTotalView
{
    if (!_scoreTotalView) {
        _scoreTotalView =[[ScoreTotalView alloc]initWithFrame:self.bounds];
    }
    return _scoreTotalView;
}
-(TiemTotalView *)tiemTotalView
{
    if (!_tiemTotalView) {
        _tiemTotalView = [[TiemTotalView alloc]initWithFrame:self.bounds];
    }
    return _tiemTotalView;
}

#pragma mark - scroViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setposition:scrollView];
    
    
    
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self setposition:scrollView];
    }
    
    
}

//调整滑动位置
-(void)setposition:(UIScrollView*)scroView
{
    if (self.scoreTimeEnum == Score_Style)
    {
        /******成绩模式*******/
        //计算出中线位置
        CGPoint point = scroView.contentOffset;
        CGFloat cen = point.x + SCREEN_WIDTH/2;
        CGFloat temp = cen - SCREEN_WIDTH/2;
        CGFloat averge = P_TO_P_WITH;
        CGFloat s = fmod(temp, averge);
        NSInteger n = floor(temp/averge);
        if (s>=0) {
            if (s>=averge/2)
            {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    scroView.contentOffset = CGPointMake((n+1)*averge  , 0);
                    
                } completion:^(BOOL finished) {
                    
                    if ([NSNumber numberWithInteger:_selectIndex]) {
                        if (_selectIndex == n+1) {
                            return ;
                        }
                        MyShapLayer *oldshaplayer = self.dataLineView.layerArray[_selectIndex];
                        oldshaplayer.fillColor = COLOR_STRING(@"#F98E38").CGColor;
                        CALayer *oldcalayer = self.dataLineView.b_layerArray[_selectIndex];
                        oldcalayer.backgroundColor = COLOR_STRING(@"#DDE5EB").CGColor;
                        
                    }
                    MyShapLayer *shaplayer = self.dataLineView.layerArray[n+1];
                    shaplayer.fillColor = [UIColor whiteColor].CGColor;
                    shaplayer.strokeColor = COLOR_STRING(@"#F98E38").CGColor;
                    CALayer *newcalayer = self.dataLineView.b_layerArray[n+1];
                    newcalayer.backgroundColor = COLOR_STRING(@"#F587A3").CGColor;
                    _selectIndex = n + 1;
                    [self SelfDelegateChosen:self.dataArray[_selectIndex]];
                    
                }];
                
            }else
            {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    scroView.contentOffset = CGPointMake((n)*averge  , 0);
                } completion:^(BOOL finished) {
                    
                    if ([NSNumber numberWithInteger:_selectIndex]) {
                        if (_selectIndex == n) {
                            return ;
                        }
                        MyShapLayer *oldshaplayer = self.dataLineView.layerArray[_selectIndex];
                        oldshaplayer.fillColor = COLOR_STRING(@"#F98E38").CGColor;
                        CALayer *oldcalayer = self.dataLineView.b_layerArray[_selectIndex];
                        oldcalayer.backgroundColor = COLOR_STRING(@"#DDE5EB").CGColor;
                        
                    }
                    MyShapLayer *shaplayer = self.dataLineView.layerArray[n];
                    shaplayer.fillColor = [UIColor whiteColor].CGColor;
                    shaplayer.strokeColor = COLOR_STRING(@"#F98E38").CGColor;
                    CALayer *newcalayer = self.dataLineView.b_layerArray[n];
                    newcalayer.backgroundColor = COLOR_STRING(@"#F587A3").CGColor;
                    _selectIndex = n ;
                    [self SelfDelegateChosen:self.dataArray[_selectIndex]];
                }];
                
            }
        }
      
        
    }else
    {
        //时间模式
        CGFloat c = colum;
        CGFloat w = with;
        CGPoint point = scroView.contentOffset;
        //计算出中线位置
        CGFloat linecenterX = point.x + SCREEN_WIDTH/2;
        CGFloat temp = linecenterX - SCREEN_WIDTH/2;
        CGFloat averge = w + c;
        CGFloat s = fmod(temp, averge);
        NSInteger n = floor(temp/averge);
        if (s >= 0) {
            if (s>= averge/2)
            {

                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    scroView.contentOffset = CGPointMake((n+1)*averge  , 0);
                } completion:^(BOOL finished) {
                    [self SelfDelegateChosen:self.dataArray[n+1]];
                    if (_selectIndex == n+1) {
                        return ;
                    }
                    TimeScore *model = self.dataArray[n+1];
                    if (model.score.floatValue > 0) {
                        
                        CAGradientLayer *layer  = self.dataColumnarView.layerArray[n+1];
                        layer.colors = nil;
                        layer.backgroundColor = COLOR_STRING(@"#5AC357").CGColor;
                        if ([NSNumber numberWithInteger:_selectIndex]) {
                            CAGradientLayer *oldLayer = self.dataColumnarView.layerArray[_selectIndex];
                            if ([oldLayer isKindOfClass:[CAGradientLayer class]]) {
                                oldLayer.colors = @[(__bridge id)COLOR_STRING(@"#5AC357").CGColor,(__bridge id)COLOR_STRING(@"#CBE8D5").CGColor];
                            }

                             _selectIndex  = n+1;
                        }
                    }
                   
                    
                }];

            }else
            {

                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    scroView.contentOffset = CGPointMake((n)*averge, 0);
                } completion:^(BOOL finished) {
                    [self SelfDelegateChosen:self.dataArray[n]];
                    if (_selectIndex == n) {
                        
                        return ;
                    }
                    TimeScore *model = self.dataArray[n];
                    if (model.score.floatValue > 0) {
                        
                        CAGradientLayer *layer  = self.dataColumnarView.layerArray[n];
                        layer.colors = nil;
                        layer.backgroundColor = COLOR_STRING(@"#5AC357").CGColor;
        
                        if ([NSNumber numberWithInteger:_selectIndex]) {
                            CAGradientLayer *oldLayer = self.dataColumnarView.layerArray[_selectIndex];
                            if ([oldLayer isKindOfClass:[CAGradientLayer class]]) {
                                oldLayer.colors = @[(__bridge id)COLOR_STRING(@"#5AC357").CGColor,(__bridge id)COLOR_STRING(@"#CBE8D5").CGColor];
                            }
          
                        }
                         _selectIndex  = n;
                    }
                   
                   
                }];
            }

        }else
        {
            return;
        }
        
    }
    
}

-(void)SelfDelegateChosen:(TimeScore*)model{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scroStop:)]) {
        [self.delegate scroStop:model];
    }
}



@end
