//
//  BKUserInfoView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKUserInfoView.h"
#import "AccountManagerViewController.h"
#import "EmViewController.h"
@implementation BKUserInfoView
//-(void)reloadData
//{
//    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:APP_DELEGATE.mLoginResult.imageUlr] placeholderImage:[UIImage imageNamed:@"userInfo_iconHold"]];
//    if (APP_DELEGATE.mLoginResult.nickName != nil && APP_DELEGATE.mLoginResult.nickName.length > 0) {
//        self.userNameLabel.text = APP_DELEGATE.mLoginResult.nickName;
//    }else{
//        self.userNameLabel.text = @"取个名字";
//    }
//
//}
//-(instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//
//       //badge_icon net_right1
//        self.userHeaderImageView = [[UIImageView alloc]init];
//        self.userNameLabel = [[UILabel alloc]init];
//        UIImageView *badgeImageView = [[UIImageView alloc]init];
//        badgeImageView.image = [UIImage imageNamed:@"badge_icon"];
//        UIImageView *rightImageView = [[UIImageView alloc]init];
//        rightImageView.image = [UIImage imageNamed:@"next_my"];
//        [self addSubview:self.userHeaderImageView];
//        [self addSubview:self.userNameLabel];
//        [self addSubview:badgeImageView];
//        [self addSubview:rightImageView];
//        self.userHeaderImageView.layer.cornerRadius = SCALE(70)/2;
//        self.userHeaderImageView.layer.masksToBounds = YES;
//        self.userNameLabel.font = [UIFont boldSystemFontOfSize:SCALE(17)];
//        [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:APP_DELEGATE.mLoginResult.imageUlr] placeholderImage:[UIImage imageNamed:@"userInfo_iconHold"]];
//        if (APP_DELEGATE.mLoginResult.nickName != nil && APP_DELEGATE.mLoginResult.nickName.length > 0) {
//           self.userNameLabel.text = APP_DELEGATE.mLoginResult.nickName;
//        }else{
//            self.userNameLabel.text = @"取个名字";
//        }
//        [self.userHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(SCALE(70), SCALE(70)));
//            make.top.mas_equalTo(self.mas_top);
//            make.bottom.mas_equalTo(self.mas_bottom);
//            make.left.mas_equalTo(self.mas_left);
//        }];
//        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.mas_equalTo(self.userHeaderImageView.mas_right).offset(14);
//            make.size.mas_equalTo(CGSizeMake(SCALE(100), 22));
//            make.top.mas_equalTo(self.userHeaderImageView.mas_top).offset(15);
//
//        }];
//        [badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(10);
//            make.left.mas_equalTo(self.userHeaderImageView.mas_right).offset(14);
//            make.size.mas_equalTo(CGSizeMake(82, 27));
//
//        }];
//
//        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self.mas_centerY);
//            make.right.mas_equalTo(self.mas_right).offset(-15);
//            make.size.mas_equalTo(CGSizeMake(SCALE(9), SCALE(14)));
//        }];
//
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userinfo)];
//        self.userInteractionEnabled = YES;
//        [self addGestureRecognizer:tap];
//
//
//        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emblem)];
//        badgeImageView.userInteractionEnabled = YES;
//        [badgeImageView addGestureRecognizer:tap1];
//    }
//    return self;
//}
//-(void)userinfo
//{
//
//    AccountManagerViewController *mAccountManagerViewController = [[AccountManagerViewController alloc] init];
//    mAccountManagerViewController.NeedFixCode = YES;
//    [APP_DELEGATE.navigationController pushViewController:mAccountManagerViewController animated:YES];
//}
//
//-(void)emblem{
//
//    EmViewController *vc = [[EmViewController alloc]init];
//    vc.url = EmblemAddress;
//    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
//}

-(void)reloadData
{
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:APP_DELEGATE.mLoginResult.imageUlr] placeholderImage:[UIImage imageNamed:@"userInfo_iconHold"]];
    if (APP_DELEGATE.mLoginResult.nickName != nil && APP_DELEGATE.mLoginResult.nickName.length > 0) {
        self.userNameLabel.text = APP_DELEGATE.mLoginResult.nickName;
    }else{
        self.userNameLabel.text = @"取个名字";
    }
//    if (APP_DELEGATE.mLoginResult.appellativeName != nil && APP_DELEGATE.mLoginResult.appellativeName.length > 0) {
//        self.userRelationLabel.text = APP_DELEGATE.mLoginResult.appellativeName;
//    }else{
//        self.userRelationLabel.text = @"其他";
//    }
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //badge_icon net_right1
        self.userHeaderImageView = [[UIImageView alloc]init];
        self.userNameLabel = [[UILabel alloc]init];
        self.userRelationLabel = [[UILabel alloc]init];
        self.memberImageView = [[UIImageView alloc]init];
        self.memberLabel = [[UILabel alloc]init];
        [self addSubview:self.userHeaderImageView];
        [self addSubview:self.userNameLabel];
        [self addSubview:self.userRelationLabel];;
        [self addSubview:self.memberLabel];
        [self addSubview:self.memberImageView];
        self.memberLabel.font = [UIFont systemFontOfSize:SCALE(11)];
        self.memberLabel.textColor = COLOR_STRING(@"#999999");
        self.userRelationLabel.textColor = COLOR_STRING(@"#999999");
        self.userNameLabel.font = [UIFont boldSystemFontOfSize:SCALE(17)];
        self.userRelationLabel.font = [UIFont systemFontOfSize:SCALE(13)];
        [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:APP_DELEGATE.mLoginResult.imageUlr] placeholderImage:[UIImage imageNamed:@"userInfo_iconHold"]];
        self.userHeaderImageView.layer.cornerRadius = SCALE(65)/2;
        self.userHeaderImageView.layer.masksToBounds = YES;
        self.userHeaderImageView.backgroundColor = [UIColor redColor];
        if (APP_DELEGATE.mLoginResult.nickName != nil && APP_DELEGATE.mLoginResult.nickName.length > 0) {
            self.userNameLabel.text = APP_DELEGATE.mLoginResult.nickName;
        }else{
            self.userNameLabel.text = @"取个名字";
        }
        CGSize size = [self.userRelationLabel sizeThatFits:CGSizeZero];
        [self.userHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCALE(65), SCALE(65)));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left);
        }];
        CGSize size1 = [self.userNameLabel sizeThatFits:CGSizeZero];
        CGFloat templ = size1.width<=100?size1.width:SCALE(100);
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.userHeaderImageView.mas_right).offset(14);
            make.size.mas_equalTo(CGSizeMake(templ, 22));
            make.top.mas_equalTo(self.userHeaderImageView.mas_top).offset(10);
            
        }];
        [self.userRelationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(self.userHeaderImageView.mas_right).offset(14);
            make.size.mas_equalTo(CGSizeMake(size.width, 15));
            
        }];
        
        [self.memberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userNameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.userNameLabel);
            make.size.mas_equalTo(CGSizeMake(SCALE(25), SCALE(30)));
        }];
        
        [self.memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.memberImageView.mas_right).offset(2);
             make.centerY.mas_equalTo(self.userNameLabel);
             make.size.mas_equalTo(CGSizeMake(SCALE(100), SCALE(30)));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userinfo)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
        
        //徽章
        UIImageView *badgeImageView = [[UIImageView alloc]init];
        badgeImageView.image = [UIImage imageNamed:@"badge_icon"];
        UIImageView *rightImageView = [[UIImageView alloc]init];
        rightImageView.image = [UIImage imageNamed:@"next_my"];
        [self addSubview:badgeImageView];
        [self addSubview:rightImageView];
        
        [badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(SCALE(5));
            make.left.mas_equalTo(self.userHeaderImageView.mas_right).offset(14);
            make.size.mas_equalTo(CGSizeMake(82, 27));
            
        }];
        
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(SCALE(9), SCALE(14)));
        }];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emblem)];
        badgeImageView.userInteractionEnabled = YES;
        [badgeImageView addGestureRecognizer:tap1];
    }
    return self;
}
-(void)userinfo
{
    
    AccountManagerViewController *mAccountManagerViewController = [[AccountManagerViewController alloc] init];
    mAccountManagerViewController.NeedFixCode = YES;
    [APP_DELEGATE.navigationController pushViewController:mAccountManagerViewController animated:YES];
}

-(void)emblem{
    
    EmViewController *vc = [[EmViewController alloc]init];
    vc.url = EmblemAddress;
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
}
@end
