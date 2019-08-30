//
//  ScoreTimeBaseController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ScoreTimeBaseController.h"
#import "English_Header.h"
#import "ScoreRemindView.h"
#import "CommonUsePackaging.h"
@interface ScoreTimeBaseController ()<ScroChosenDelegate>

@end

@implementation ScoreTimeBaseController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self.view addSubview:self.drawingView];
    [self.view addSubview:self.scoreMidView];
    [self.view addSubview:self.scoreBottomView];
    // Do any additional setup after loading the view.
}
-(ScoreMidView *)scoreMidView
{
    if (!_scoreMidView) {
        _scoreMidView = [[ScoreMidView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawingView.frame),SCREEN_WIDTH ,SCALE(180))];
        _scoreMidView.userInteractionEnabled = YES;
    
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reminder:)];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reminder:)];
//
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reminder:)];
        UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reminder:)];
        _scoreMidView.timeLable.userInteractionEnabled =YES;
        _scoreMidView.wordRepeatLable.userInteractionEnabled =YES;
        _scoreMidView.voiceLable.userInteractionEnabled =YES;
        _scoreMidView.fluencyLable.userInteractionEnabled =YES;
        [_scoreMidView.timeLable addGestureRecognizer:tap1];
        [_scoreMidView.wordRepeatLable addGestureRecognizer:tap2];
        [_scoreMidView.voiceLable addGestureRecognizer:tap3];
        [_scoreMidView.fluencyLable addGestureRecognizer:tap4];
    }
    return _scoreMidView;
}

-(DrawingView *)drawingView
{
    if (!_drawingView) {
        
        _drawingView = [[DrawingView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH-SCALE(140))];
        _drawingView.delegate = self;
    }
    return _drawingView;
}

-(ScoreBottomView *)scoreBottomView
{
    if (!_scoreBottomView) {
        _scoreBottomView = [[ScoreBottomView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scoreMidView.frame),SCREEN_WIDTH  ,SCREEN_WIDTH*161/375)];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reminder:)];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reminder:)];
        _scoreBottomView.bookView.userInteractionEnabled =YES;
        _scoreBottomView.wordView.userInteractionEnabled =YES;
        [_scoreBottomView.bookView addGestureRecognizer:tap1];
        [_scoreBottomView.wordView addGestureRecognizer:tap2];
    }
    return _scoreBottomView;
}
#pragma mark - action
-(void)reminder:(UITapGestureRecognizer*)tap{
    
    NSString *info=@"";
    NSString * title =@"";
    if ([tap.view isEqual: self.scoreMidView.timeLable]) {
        info = @"整个跟读评测总体得分平均值";
        title = @"总成绩";
    }else if ([tap.view isEqual: self.scoreMidView.wordRepeatLable])
    {
        info = @"已学习绘本的跟读评测词汇重音得分平均值";
        title = @"重音得分";
        
    }else if ([tap.view isEqual: self.scoreMidView.voiceLable])
    {
        info = @"已学习绘本的跟读评测词汇音素得分平均值(音素即构成语义区分的最小发音单元，如含有[tʃ]的单词：chocolate、cheese，含有[n]的单词：sun, fine, name等) ";
        title = @"音素得分";
        
    }else if ([tap.view isEqual: self.scoreMidView.fluencyLable])
    {
        info = @"已学习绘本的跟读评测句子流利程度得分平均值";
        title = @"流利度得分";
        
    }else if ([tap.view isEqual: self.scoreBottomView.bookView])
    {
        info = @"按已学习的绘本去重统计（同一本不累加）";
        title = @"阅读本书";
    }else if ([tap.view isEqual: self.scoreBottomView.wordView])
    {
        info = @"已学习绘本中完成跟读评测的词汇总和";
        title = @"词汇量";
    }
    ScoreRemindView *reminde =[[ScoreRemindView alloc]initWithFrame:[UIScreen mainScreen].bounds Title:title Info:info ImageName:@"kidbook_image" Block:^{
        
        NSLog(@"知道了");
    }];
    [APP_DELEGATE.window addSubview:reminde];
}

#pragma mark - ScroChosenDelegate
-(void)scroStop:(TimeScore *)timeScore
{
    if (timeScore == nil) {
        if (self.drawingView.scoreTimeEnum == Score_Style)
        {
            
            NSString *time = @"00分";
            self.scoreMidView.timeLable.attributedText = [CommonUsePackaging getAttributes:time Color:[UIColor blackColor]];
            
        }else
        {
            NSString *scroe = @"00";
            self.scoreMidView.timeLable.attributedText = [self getAttribute:[NSString stringWithFormat:@"%@",scroe]];
            
        }
        return;
    }
    
    if (self.drawingView.scoreTimeEnum == Score_Style)
    {
        
        NSString *time = [CommonUsePackaging Time_format:timeScore.timeAndScore];
        self.scoreMidView.timeLable.attributedText = [CommonUsePackaging getAttributes:time Color:[UIColor blackColor]];
     
    }else
    {
        self.scoreMidView.timeLable.attributedText = [self getAttribute:[NSString stringWithFormat:@"%@",timeScore.timeAndScore]];
        
    }
    
    self.scoreMidView.wordRepeatLable.text = [NSString stringWithFormat:@"%@",timeScore.stress];
    self.scoreMidView.voiceLable.text = [NSString stringWithFormat:@"%@",timeScore.phone];
    self.scoreMidView.fluencyLable.text = [NSString stringWithFormat:@"%@",timeScore.fluency];
    self.scoreBottomView.bookView.dataLabel.text = [NSString stringWithFormat:@"%@",timeScore.book];
    self.scoreBottomView.wordView.dataLabel.text = [NSString stringWithFormat:@"%@",timeScore.word];
    
    
}
-(NSMutableAttributedString *)getAttribute:(NSString *)string{
    NSString *str;
    if (self.drawingView.scoreTimeEnum == Score_Style)
    {
         str = [NSString stringWithFormat:@"%@分钟",string];
    }else
    {
        str = [NSString stringWithFormat:@"总成绩%@分",string];
    }
    
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:str];
    //    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    //    NSRange range = [string rangeOfString:@"/"];
    //    NSRange pointRange = NSMakeRange(0, range.location);
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    dic[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    //    //赋值
    //    [attribut addAttributes:dic range:pointRange];
    
    NSRange range = [str rangeOfString:string];
    [attribut addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:50],NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName,nil] range:range];
    return attribut;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
