//
//  BKCenterHeaderView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCenterHeaderView.h"
#import "BKMyBtton.h"
#import "UIResponder+Event.h"
#import "UIButton+WebCache.h"
#import "BabyInfoAddController.h"
#import "CommonUsePackaging.h"
#import "BKMemberWebController.h"
@interface BKCenterHeaderView()
@end
@implementation BKCenterHeaderView

-(instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALE(164)+SCALE(143));
        UIImageView *backGroungImagView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cnter_head_bg_iamge"]];
        backGroungImagView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALE(164));
        [self addSubview:backGroungImagView];
        
        UIImageView *backGroungImagView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cnter_head_bg_img2"]];
        backGroungImagView2.frame = CGRectMake(0, CGRectGetMaxY(backGroungImagView.frame), SCREEN_WIDTH, SCALE(143));
        [self addSubview:backGroungImagView2];
        [self addSubview:self.userInfoView];
        [self addSubview: self.addBabyInfoView];
        [self addSubview:self.btnlistView];
        self.newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if(APP_DELEGATE.mLoginResult.SN != nil && APP_DELEGATE.mLoginResult.SN.length > 0)
        {
            if ([CommonUsePackaging shareInstance].isHadNoticeRemind) {
                
                [self.newsButton setImage:[UIImage imageNamed:@"news_small_black_yes"] forState:UIControlStateNormal];
            }else
            {
                
                [self.newsButton setImage:[UIImage imageNamed:@"news_small_blace"] forState:UIControlStateNormal];
            }
        }else
        {
            [self.newsButton setImage:[UIImage imageNamed:@"news_small_blace"] forState:UIControlStateNormal];
        }
       
        
        [self addSubview:self.newsButton];
        [self.newsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(self.mas_top).offset(19);
            make.right.mas_equalTo(self.mas_right).offset(-11);
        }];
        [self.newsButton addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

#pragma mark -懒加载
-(UIImageView *)memberImageView
{
    if (!_memberImageView) {
        _memberImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buy_vip_car"]];
//        _memberImageView.backgroundColor = [UIColor redColor];
        _memberImageView.frame = CGRectMake(SCALE(15), CGRectGetMaxY(self.btnlistView.frame) + SCALE(10), SCALE(346),SCALE(45));
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyMember)];
        _memberImageView.userInteractionEnabled = YES;
        [_memberImageView addGestureRecognizer:tap];
    }
    return _memberImageView;
}
-(BKCenterBtnListCell *)btnlistView
{
    if (!_btnlistView) {
        _btnlistView = [[BKCenterBtnListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        _btnlistView.frame = CGRectMake(SCALE(15), CGRectGetMaxY(self.addBabyInfoView.frame) + SCALE(10), SCALE(346), SCALE(90));
        _btnlistView.backgroundColor = [UIColor whiteColor];
    }
    return _btnlistView;
}
-(BKUserInfoView *)userInfoView
{
    if (!_userInfoView) {
        _userInfoView = [[BKUserInfoView alloc]initWithFrame:CGRectMake(SCALE(15),SCALE(60), SCREEN_WIDTH-15, SCALE(70))];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyMember)];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyMember)];
        _userInfoView.memberLabel.userInteractionEnabled = YES;
        _userInfoView.memberImageView.userInteractionEnabled = YES;
        [_userInfoView.memberLabel addGestureRecognizer:tap1];
        [_userInfoView.memberImageView addGestureRecognizer:tap2];
    }
    return _userInfoView;
}

-(AddBabyInfoView *)addBabyInfoView
{
    if (!_addBabyInfoView) {
        _addBabyInfoView = [[AddBabyInfoView alloc]initWithFrame:CGRectMake(SCALE(15), SCALE(151), SCALE(345), SCALE(45))];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addinfo)];
        _addBabyInfoView.userInteractionEnabled = YES;
        [_addBabyInfoView addGestureRecognizer:tap];
    }
    return _addBabyInfoView;
}
-(void)setBabyRobotInfo:(BabyRobotInfo *)babyRobotInfo
{
   
    _babyRobotInfo = babyRobotInfo;
   
    UIImage *placeImage = babyRobotInfo.babyGender == 0?[UIImage imageNamed:@"id_image_default boy"]:[UIImage imageNamed:@"baby_default image_girl"];
    [self.addBabyInfoView.addButton sd_setImageWithURL:[NSURL URLWithString:self.babyRobotInfo.babyImageUrl] forState:UIControlStateNormal placeholderImage:placeImage];
    self.addBabyInfoView.topLabel.text = self.babyRobotInfo.babyNickName.length?self.babyRobotInfo.babyNickName:@"宝贝";
    self.addBabyInfoView.downLabel.text = [self getAgeFromDate:self.babyRobotInfo.babyBirthday];
//    self.addBabyInfoView.editImageView.hidden = NO;
    CGSize size = [self.addBabyInfoView.topLabel sizeThatFits:CGSizeZero];
    [self.addBabyInfoView.topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size.width, 25));
    }];
//    [self.addBabyInfoView.editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.addBabyInfoView.downLabel.mas_right).offset(8);
//        make.centerY.mas_equalTo(self.addBabyInfoView.downLabel.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(12, 12));
//    }];
}
-(void)setMemberInfo:(MemberInfo *)memberInfo
{
    _memberInfo = memberInfo;
    
    if (memberInfo.isSH) {
        self.userInfoView.memberLabel.hidden = NO;
        self.userInfoView.memberImageView.hidden = NO;
        self.userInfoView.memberLabel.text =  @"尊享会员";
        [self.userInfoView.memberImageView sd_setImageWithURL:[NSURL URLWithString:_memberInfo.memberImg]];
        if (_memberInfo.isMemberActive) {
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALE(164)+SCALE(143));
            [self layoutIfNeeded];
            if ([self.subviews containsObject:self.memberImageView]) {
                [self.memberImageView removeFromSuperview];
            }
        }else
        {
            
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALE(164)+SCALE(199));
            [self layoutIfNeeded];
            if (![self.subviews containsObject:self.memberImageView]) {
                [self addSubview:self.memberImageView];
            }
            
        }
    }else
    {
        self.userInfoView.memberLabel.hidden = YES;
        self.userInfoView.memberImageView.hidden = YES;
        
    }
    
}

#pragma mark - 计算宝贝年龄
-(NSString*)getAgeFromDate:(NSString*)dateStr{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyy-MM-dd";
    NSDate *bidate = [dateFormatter dateFromString:dateStr];
    NSDate *nowDate = [NSDate date];
      NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSInteger time = [nowDate timeIntervalSinceDate:bidate];
    NSCalendarUnit unit = NSCalendarUnitYear;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:bidate toDate:nowDate options:0];
    //获取其中的"天"
//    NSLog(@"delta.day:%ld",delta.day);
//    NSInteger year
    
    return [NSString stringWithFormat:@"%ld岁",delta.year];
}
#pragma mark action
-(void)talk{
    
    [self eventName:BKCenterHeaderView_Event Params:nil];
    
}

-(void)addinfo{
    
//    [self eventName:BKCenterHeaderView_Event Params:BKCenterHeaderView_BabyInfo];
    BabyInfoAddController *vc= [[BabyInfoAddController alloc]init];
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    
    [[BaiduMobStat defaultStat] logEvent:@"c_baInfo100" eventLabel:@"我的"];
}
-(void)buyMember{
    
    BKMemberWebController *vc = [[BKMemberWebController alloc]init];
    if (self.memberInfo) {
         vc.memberInfo = self.memberInfo;
    }
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    
}
@end
