//
//  StoryBaseViewController.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryBaseViewController : UIViewController

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UILabel *titleLabel;


@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UIColor *backgroundColor;

@property(nonatomic,copy) NSString *titleString;
@property(nonatomic,strong) UIColor *titleColor;
@property(nonatomic,strong) UIFont *titleFont;

@property(nonatomic,strong) UIImage *backImage;

@end
