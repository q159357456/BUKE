//
//  EnglishTableHeader.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EnglishTableHeader.h"
#import "FetchBabyInfoService.h"
#import "BabyRobotInfo.h"
#import "English_Header.h"
#import "EnglishScore.h"
#import "OJRNViewController.h"
#import "BabyInfoViewController.h"
#import "ScoreTimeRecorderVC.h"
#import "BabyInfoAddController.h"

@interface EnglishTableHeader ()
@property(nonatomic,strong)UIImageView *header_image_view;
@property(nonatomic,strong)UILabel *name_label;
@property(nonatomic,strong)UIImageView * animation_view;
@property(nonatomic,strong)UIImageView *top_background_view;
@property(nonatomic,strong)UIImageView *bottom_background_view;
@property(nonatomic,strong)UIImageView *title_imageview;
@property(nonatomic,strong)UIView *gradeView;
@property (nonatomic,strong) NSTimer* mUpdateAnimationTimer;
@property (nonatomic,strong) NSTimer* mStartAnimationTimer;

@end
@implementation EnglishTableHeader
+(instancetype)table_headerWithFrame:(CGRect)frame{
    
    EnglishTableHeader *header = [[EnglishTableHeader alloc]initWithFrame:frame];
    return header;
}
-(void)reloadData
{
    [self getBabyInfo];
    [self getenglishScore];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initsubview];
        [self getBabyInfo];
        [self getenglishScore];
    }
    
    return self;
}

-(UIView *)gradeView
{
    if (!_gradeView) {
        _gradeView=[[UIView alloc]initWithFrame:
                    CGRectMake(SCALE(15), SCALE(100), SCREEN_WIDTH - SCALE(15)*2, SCALE(150))];
        UIImageView *backGround = [[UIImageView alloc]initWithFrame:_gradeView.bounds];
        backGround.image = [UIImage imageNamed:@"home_results_panel.png"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rn_text)];
        _gradeView.userInteractionEnabled = YES;
        [_gradeView addGestureRecognizer:tap];
        [_gradeView addSubview:backGround];
        NSArray *imageList = @[@"word.png",@"score.png",@"book.png"];
        NSArray *titleList = @[@"新增词汇",@"学习成绩",@"成绩变化"];
        CGFloat with = _gradeView.frame.size.width;
        CGFloat lab_with = SCALE(80);
        CGFloat imagesize = SCALE(45);
        for (NSInteger i = 0; i<3; i++) {
            UILabel *lable1 =[[UILabel alloc]init];
            lable1.textAlignment = NSTextAlignmentCenter;
            lable1.font = [UIFont systemFontOfSize:SCALE(13) weight:UIFontWeightMedium];
            lable1.textColor = [UIColor whiteColor];
            
            UIImageView *imageview = [[UIImageView alloc]init];
            imageview.image = [UIImage imageNamed:imageList[i]];
            UILabel *lable2  = [[UILabel alloc]init];
            lable2.font = [UIFont systemFontOfSize:SCALE(13) weight:UIFontWeightMedium];
            lable2.textAlignment = NSTextAlignmentCenter;
            lable2.textColor = [UIColor whiteColor];
            lable1.text = titleList[i];
            lable2.tag = i + 100;
            [_gradeView addSubview:lable1];
            [_gradeView addSubview:lable2];
            [_gradeView addSubview:imageview];
            [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_gradeView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(imagesize, imagesize));
                make.left.mas_equalTo(((with-imagesize*3)/4 +imagesize)*i + (with-imagesize*3)/4);
            
                
            }];
            [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.mas_equalTo(imageview.mas_top).offset(-5);
                make.size.mas_equalTo(CGSizeMake(lab_with, SCALE(20)));
                make.centerX.mas_equalTo(imageview.mas_centerX);
                
            }];
            [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(imageview.mas_bottom).offset(5);
                make.size.mas_equalTo(CGSizeMake(lab_with, SCALE(20)));
                make.centerX.mas_equalTo(imageview.mas_centerX);
                
            }];
           
           
            
        }
        
    }
    return _gradeView;
}
#pragma mark - action
-(void)babyInfo{
    
//    BabyInfoViewController *mBabyInfoViewController = [[BabyInfoViewController alloc] init];
//    [APP_DELEGATE.navigationController pushViewController:mBabyInfoViewController animated:YES];
    //跳转宝贝信息
    BabyInfoAddController *vc= [[BabyInfoAddController alloc]init];
//    [MobClick event:EVENT_BABY_INFO_9];
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    
    [[BaiduMobStat defaultStat] logEvent:@"c_baInfo100" eventLabel:@"英语"];
}
-(void)rn_text{
    //    [self eventName:@"" Params:nil];
//    OJRNViewController *rn = [[OJRNViewController alloc]init];
//    rn.title = @"rn_text";
//    [APP_DELEGATE.navigationController pushViewController:rn animated:YES];
    ScoreTimeRecorderVC *vc = [[ScoreTimeRecorderVC alloc]init];
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
}

#pragma mark - initsubview
-(void)initsubview{
    self.top_background_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALE(128))];
    _top_background_view.image = [UIImage imageNamed:@"home_bg1"];
    [self addSubview:_top_background_view];
    
    
//    _bottom_background_view = [[UIImageView alloc]initWithFrame:CGRectMake(20, SCALE(98), SCREEN_WIDTH - 40, SCALE(150))];
//    _bottom_background_view.image = [UIImage imageNamed:@"home_results_panel"];
     [self addSubview:self.gradeView];
    

    _header_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCALE(45), SCALE(45))];
    _header_image_view.center = CGPointMake(SCALE(40), _top_background_view.frame.size.height/2-10);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(babyInfo)];
    _top_background_view.userInteractionEnabled = YES;
    _header_image_view.userInteractionEnabled = YES;
    [_header_image_view addGestureRecognizer:tap];
    _header_image_view.image = [UIImage imageNamed:@"id_image_default boy"];
    _header_image_view.layer.cornerRadius = SCALE(22.5);
    _header_image_view.layer.masksToBounds = YES;
    _header_image_view.layer.borderWidth = 2.0f;
    _header_image_view.layer.borderColor = [UIColor whiteColor].CGColor;
    [_top_background_view addSubview:_header_image_view];
    
    
    _name_label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_header_image_view.frame) + 10, _header_image_view.center.y-11, 150, 22)];
    _name_label.textColor = [UIColor whiteColor];
    _name_label.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:21];
    _name_label.text = @"宝贝";
    _name_label.font = [UIFont boldSystemFontOfSize:SCALE(21)];

    
    [_top_background_view addSubview:_name_label];
    
    _animation_view = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - SCALE(95), SCALE(28), SCALE(86), SCALE(70))];

    [_top_background_view addSubview:_animation_view];
    dispatch_async(dispatch_get_main_queue() , ^{
        
        [self startAnimation:_animation_view];
        self.mUpdateAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(OnTimer) userInfo:nil repeats:NO];
    });
 
    
    
    
   _title_imageview = [[UIImageView alloc]initWithFrame:CGRectMake(SCALE(375 - 140), SCALE(86), SCALE(102), SCALE(33))];
    _title_imageview.image = [UIImage imageNamed:@"home_study_image"];
   [self addSubview:_title_imageview];

}

-(void)OnTimer {
    self.mStartAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(OnStartTimer) userInfo:nil repeats:NO];
    
}

-(void)OnStartTimer {
//    [self.mStartAnimationTimer invalidate];
    [_animation_view startAnimating];
    self.mUpdateAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(OnTimer) userInfo:nil repeats:NO];
}

-(void) startAnimation:(UIImageView *) imageView1
{
    // UIImageView动画（播放序列图）
    // 1.将序列图加入数组
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    for(int i=0;i<=32;i++)
    {
        UIImage *image = nil;
        if (i >=10) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"xiaobuke_en_000%d",i]];
        } else {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"xiaobuke_en_0000%d",i]];
        }
        
        [imagesArray addObject:image];
    }
//    UIImageView *imageView1 = [[UIImageView alloc] init];
//    imageView1.frame = CGRectMake(10, 200, 300, 217);
//    imageView1.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:imageView1];
    // 设置序列图数组
    imageView1.animationImages = imagesArray;
    
    
    [imageView1 setImage:[UIImage imageNamed:@"xiaobuke_en_00032"]];
    // 设置播放周期时间
    imageView1.animationDuration = 2;
    // 设置播放次数
    imageView1.animationRepeatCount = 1;
    // 播放动画
    [imageView1 startAnimating];

}


#pragma mark - 获取宝贝信息
-(void)getBabyInfo
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface, NSString *description){
        NSLog(@"FetchBabyInfoService===>OnSuccess");
        
        FetchBabyInfoService *service = (FetchBabyInfoService *)httpInterface;
        NSDictionary *babyDic = service.babyDic;
        if (babyDic != nil) {
            BabyRobotInfo *babyInfo = [BabyRobotInfo parseDataByDictionary:babyDic];
            self.name_label.text = babyInfo.babyNickName.length?babyInfo.babyNickName:@"宝贝";
            UIImage *placeimage=  babyInfo.babyGender == 0?[UIImage imageNamed:@"id_image_default boy"]:[UIImage imageNamed:@"baby_default image_girl"];
            [self.header_image_view sd_setImageWithURL:[NSURL URLWithString:[babyInfo.babyImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:placeimage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"sd_setImageWithURL ===> %@",error);
                if (image) {
                    [self.header_image_view setImage:image];
                }
            }];
            
        }
        
    };
    
    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"FetchBabyInfoService===>OnError");
        NSLog(@"FetchBabyInfoService--->%@",description);
    };
    
    FetchBabyInfoService *babyService = [[FetchBabyInfoService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
    [babyService start];
}
-(void)getenglishScore{
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface, NSString *description){
        NSLog(@"FetchBabyInfoService===>OnSuccess");
        
        EnglishScore *service = (EnglishScore *)httpInterface;

        if (service.score) {
            UILabel *lable1 = [self.gradeView viewWithTag:100];
            UILabel *lable2 = [self.gradeView viewWithTag:101];
            UILabel *lable3 = [self.gradeView viewWithTag:102];
            lable1.text = [NSString stringWithFormat:@"%@",service.score.wordCount];
            lable2.text = [NSString stringWithFormat:@"%@",service.score.score];
            lable3.text = [NSString stringWithFormat:@"%@",service.score.change];
        
        }
        
    };
    
    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
      
        NSLog(@"EnglishScore--->%@",description);
    };
    
    EnglishScore *babyService = [[EnglishScore alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
    [babyService start];
    
}
@end

@implementation HeaderSubView


@end
