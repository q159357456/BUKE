//
//  IntensTableHeadView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "IntensTableHeadView.h"
#import "RecommandView.h"
#import "TagLabel.h"
#import "UIResponder+Event.h"
@implementation IntensTableHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
         self.backgroundColor = A_COLOR_STRING(0x666666, 0.5);
       
        self.backGImageView = [[UIImageView alloc]initWithFrame:self.bounds];
//        [self.backGImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.backGImageView];
        //毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = self.backGImageView.bounds;
        [self.backGImageView addSubview:effectView];
        
      
        
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    
    self.imageView = [[UIImageView alloc]init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    self.imageView.layer.cornerRadius = 8;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 1;
    self.lable = [[UILabel alloc]init];
    self.lable.text = @"";
    self.lable.textColor = [UIColor whiteColor];
    [self addSubview:self.imageView];
    [self addSubview:self.lable];
    [self addSubview:button];
    
   
    self.imageView.frame = CGRectMake(SCALE(15), 80, SCALE(105), SCALE(105));
    button.frame = self.imageView.frame;
    [button addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    self.lable.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.lable.font = [UIFont systemFontOfSize:SCALE(16)];
    self.lable.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+SCALE(20), SCALE(95), 200, 17);
}
-(void)play:(UIButton*)btn{
    
    [self eventName:IntensTableHeadView_Event Params:nil];
    
}
-(void)setInstensiveDetailModel:(InstensiveDetailModel *)instensiveDetailModel
{
    _instensiveDetailModel = instensiveDetailModel;
    [self.backGImageView sd_setImageWithURL:[NSURL URLWithString:instensiveDetailModel.cover]];
 
     [self.imageView sd_setImageWithURL:[NSURL URLWithString:instensiveDetailModel.cover] placeholderImage:[UIImage imageNamed:@"place_kidbook_c"]];
    self.lable.text = [NSString stringWithFormat:@"《%@》",instensiveDetailModel.bookName];
    instensiveDetailModel.forAge = instensiveDetailModel.forAge.length?instensiveDetailModel.forAge:@"";
    instensiveDetailModel.categoryTag= instensiveDetailModel.categoryTag.length?instensiveDetailModel.categoryTag:@"";
    instensiveDetailModel.themeTag = instensiveDetailModel.themeTag.length?instensiveDetailModel.themeTag:@"";
    instensiveDetailModel.forAge = instensiveDetailModel.forAge.length?instensiveDetailModel.forAge:@"";
//    NSLog(@"recommend==>%@",instensiveDetailModel.recommend);
//    NSLog(@"hard==>%@",instensiveDetailModel.hard);
    instensiveDetailModel.recommend= instensiveDetailModel.recommend.length?instensiveDetailModel.recommend:@"0";
    instensiveDetailModel.hard = instensiveDetailModel.hard.length?instensiveDetailModel.hard:@"0";
    
    NSArray *tagArray = @[instensiveDetailModel.forAge,instensiveDetailModel.categoryTag,instensiveDetailModel.themeTag];
    NSArray *starArrry = @[instensiveDetailModel.recommend,instensiveDetailModel.hard];
    
    NSInteger recommandC = 0;
    NSArray *titleArray = @[@"推荐指数",@"阅读难度"];
    for (NSInteger i=0; i<starArrry.count; i++) {
        NSString *str = starArrry[i];
        if (str.length>0) {
            RecommandView *recommand = [[RecommandView alloc]initWithFrame:CGRectMake(self.lable.frame.origin.x + SCALE(recommandC*120) , CGRectGetMaxY(self.lable.frame)+20, SCALE(110), 18) Title:titleArray[i]];
            recommand.starCount = [str integerValue];
            [self addSubview:recommand];

            recommandC ++;
        }
        
    }
    
    CGFloat w = 0;
    for (NSInteger i=0; i<tagArray.count; i++) {
        NSString *temp = tagArray[i];
        if (temp.length > 0) {
        TagLabel *tag = [[TagLabel alloc]initWithFrame:CGRectMake(self.lable.frame.origin.x + w, CGRectGetMaxY(self.lable.frame)+45, 80, 15) Text:temp];
            [self addSubview:tag];
            w = w + tag.bounds.size.width+10;
        }
        
    }
    
    
}



@end
