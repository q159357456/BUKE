//
//  LeftMenuView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//


#import "LeftMenuView.h"
#import "BabyInfoViewController.h"
#import "UIImageView+WebCache.h"

@interface LeftMenuView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIScrollView *myScrollView;

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *signatureLabel;

@property (nonatomic,strong) UIButton *babyButton;
@property (nonatomic,strong) UIButton *memberButton;

@property (nonatomic,strong) UIButton *deviceButton;
@property (nonatomic,strong) UIButton *shopDeviceButton;

@property (nonatomic,strong) UIButton *commonIssueButton;
@property (nonatomic,strong) UIButton *coupleBackButton;
@property (nonatomic,strong) UIButton *aboutButton;

@property (nonatomic,strong) UIButton *exitButton;
@property (nonatomic,strong) UIImageView *exitImageView;
@property (nonatomic,strong) UIImageView *versionImageView;

@end

@implementation LeftMenuView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return  self;
}

-(void)initView{
    //[self setBackgroundColor: COLOR_STRING(@"#FFFFFF")];
    
    _topView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, 134)];
//    [_topView setBackgroundColor: COLOR_STRING(@"#FF6723")];
    [_topView setBackgroundColor: COLOR_STRING(@"#F7F9FB")];

    [self addSubview:_topView];
    
    _bottomView = [[UIView alloc] initWithFrame: CGRectMake(0, 134, self.frame.size.width, self.frame.size.height - 134)];
    [_bottomView setBackgroundColor: COLOR_STRING(@"#FFFFFF")];
    [self addSubview:_bottomView];
    
    [self addTopViewChild];
    [self addBottomViewChild];
}


-(void) addTopViewChild
{
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (_topView.frame.size.height - 60)*0.5, 60, 60)];
    //[_headImageView setImage: [UIImage imageNamed:@"ic_play_image"]];
    //[_headImageView setBackgroundColor:[UIColor whiteColor] ];
    _headImageView.layer.cornerRadius = 60 * 0.5;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.borderWidth = 2;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [_topView addSubview:_headImageView];
    
//    if (APP_DELEGATE.mLoginResult.imageUlr != nil && APP_DELEGATE.mLoginResult.imageUlr.length != 0) {
//        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[APP_DELEGATE.mLoginResult.imageUlr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@""]];
//    }else{
//        _headImageView.image = [UIImage imageNamed:@"userInfo_iconHold"];
//    }
    
    if (self.imageUlr != nil && self.imageUlr.length != 0) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[self.imageUlr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@""]];
    }else{
        _headImageView.image = [UIImage imageNamed:@"children"];
    }
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.frame.origin.x + _headImageView.frame.size.width + 17, (_topView.frame.size.height - 20)*0.5 - 5, 100, 20)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    if (APP_DELEGATE.mLoginResult.nickName != nil && APP_DELEGATE.mLoginResult.nickName.length > 0) {
        _nameLabel.text = APP_DELEGATE.mLoginResult.nickName;
    }else{
        _nameLabel.text = @"取个名字";
    }
//    _nameLabel.text = APP_DELEGATE.mLoginResult.nickName? : @"";
    UIFont *nameFont = MY_FONT(16);
    _nameLabel.font = nameFont;
    _nameLabel.textColor = COLOR_STRING(@"#2F2F2F");

    CGSize nameSize = [_nameLabel.text sizeWithAttributes:@{NSFontAttributeName:nameFont}];
    _nameLabel.frame = CGRectMake(_headImageView.frame.origin.x + _headImageView.frame.size.width + 17, (_topView.frame.size.height - 20)*0.5 - 5, nameSize.width, 20);
    [_topView addSubview: _nameLabel];
    
    UIImageView *indicateImageView = [[UIImageView alloc] init];
//    indicateImageView.image = [UIImage imageNamed:@"userInfo_indicate"];
    indicateImageView.image = [UIImage imageNamed:@"back_indicate"];

    [_topView addSubview:indicateImageView];
    [indicateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_right).offset(9);
        make.centerY.mas_equalTo(_nameLabel);
        make.size.mas_equalTo(CGSizeMake(6, 11));
    }];
    
    _signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x,_nameLabel.frame.origin.y + _nameLabel.frame.size.height,150, 20)];
    _signatureLabel.textAlignment = NSTextAlignmentLeft;
    _signatureLabel.text = APP_DELEGATE.mLoginResult.appellativeName ? : @"";
//    _signatureLabel.text = self.appellativeName ? : @"";
    _signatureLabel.font = MY_FONT(12);
    _signatureLabel.textColor = COLOR_STRING(@"#999999");
    [self addSubview: _signatureLabel];
    
    NSLog(@"用户信息===>%@",APP_DELEGATE.mLoginResult.appellativeName);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserInfo:)];
    [_topView addGestureRecognizer:tap];
}

-(void) addBottomViewChild
{
    _myScrollView = [[UIScrollView alloc]initWithFrame:
                     CGRectMake(0, 0, _bottomView.frame.size.width, _bottomView.frame.size.height - 30)];
    //[_myScrollView setBackgroundColor:[UIColor redColor]];
    _myScrollView.accessibilityActivationPoint = CGPointMake(100, 100);
    //    imgView = [[UIImageView alloc]initWithImage:
    //               [UIImage imageNamed:@"AppleUSA.jpg"]];
    //    [myScrollView addSubview:imgView];
    _myScrollView.minimumZoomScale = 0.5;
    _myScrollView.maximumZoomScale = 3;
    
    _myScrollView.delegate = self;
    [_myScrollView setShowsVerticalScrollIndicator:NO];
    [_bottomView addSubview:_myScrollView];
    
    _babyButton = [[UIButton alloc] initWithFrame:CGRectMake(20,30, self.frame.size.width - 30, 50)];
    [_babyButton setTitle:@"宝贝信息" forState:UIControlStateNormal];
    //[_babyButton setBackgroundColor: [UIColor redColor] ];
    [_babyButton.titleLabel setFont:MY_FONT(17)];
    [_babyButton setTitleColor:COLOR_STRING(@"#444444") forState:UIControlStateNormal];
    [_babyButton addTarget:self action:@selector(babyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _babyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [_myScrollView addSubview: _babyButton];
    
    _memberButton = [[UIButton alloc] initWithFrame:CGRectMake(_babyButton.frame.origin.x,_babyButton.frame.origin.y + 50, _babyButton.frame.size.width, 50)];
    [_memberButton setTitle:@"成员管理" forState:UIControlStateNormal];
    [_memberButton.titleLabel setFont:MY_FONT(17)];
    [_memberButton setTitleColor:COLOR_STRING(@"#444444") forState:UIControlStateNormal];
    [_memberButton addTarget:self action:@selector(memberButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _memberButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_myScrollView addSubview: _memberButton];
    
    _deviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _deviceButton.frame = CGRectMake(_memberButton.frame.origin.x,_babyButton.frame.origin.y + 50, _memberButton.frame.size.width, 50);
    _deviceButton.frame = CGRectMake(_memberButton.frame.origin.x,_memberButton.frame.origin.y + 50, _memberButton.frame.size.width, 50);
    [_deviceButton setTitle:@"设备管理" forState:UIControlStateNormal];
    [_deviceButton.titleLabel setFont:MY_FONT(17)];
    [_deviceButton setTitleColor:COLOR_STRING(@"#444444") forState:UIControlStateNormal];
    [_deviceButton addTarget:self action:@selector(deviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _deviceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_myScrollView addSubview: _deviceButton];
    
    
    _shopDeviceButton = [[UIButton alloc] initWithFrame:CGRectMake(_deviceButton.frame.origin.x,_deviceButton.frame.origin.y + 50, _deviceButton.frame.size.width, 50)];
    [_shopDeviceButton setTitle:@"购买设备" forState:UIControlStateNormal];
    [_shopDeviceButton.titleLabel setFont:MY_FONT(17)];
    [_shopDeviceButton setTitleColor:COLOR_STRING(@"#444444") forState:UIControlStateNormal];
    [_shopDeviceButton addTarget:self action:@selector(shopDeviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _shopDeviceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_myScrollView addSubview: _shopDeviceButton];
    
    _commonIssueButton = [[UIButton alloc] initWithFrame:CGRectMake(_shopDeviceButton.frame.origin.x,_shopDeviceButton.frame.origin.y + 50, _shopDeviceButton.frame.size.width, 50)];
    [_commonIssueButton setTitle:@"在线帮助" forState:UIControlStateNormal];
    [_commonIssueButton.titleLabel setFont:MY_FONT(17)];
    [_commonIssueButton setTitleColor:COLOR_STRING(@"#444444") forState:UIControlStateNormal];
    [_commonIssueButton addTarget:self action:@selector(commonIssueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _commonIssueButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_myScrollView addSubview: _commonIssueButton];
    
    _coupleBackButton = [[UIButton alloc] initWithFrame:CGRectMake(_commonIssueButton.frame.origin.x,_commonIssueButton.frame.origin.y + 50, _commonIssueButton.frame.size.width, 50)];
    [_coupleBackButton setTitle:@"意见反馈" forState:UIControlStateNormal];
    [_coupleBackButton.titleLabel setFont:MY_FONT(17)];
    [_coupleBackButton setTitleColor:COLOR_STRING(@"#444444") forState:UIControlStateNormal];
    [_coupleBackButton addTarget:self action:@selector(feedbackClick:) forControlEvents:UIControlEventTouchUpInside];
    _coupleBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_myScrollView addSubview: _coupleBackButton];
    
    _aboutButton = [[UIButton alloc] initWithFrame:CGRectMake(_coupleBackButton.frame.origin.x,_coupleBackButton.frame.origin.y + 50, _coupleBackButton.frame.size.width, 50)];
    [_aboutButton setTitle:@"关于" forState:UIControlStateNormal];
    [_aboutButton.titleLabel setFont:MY_FONT(17)];
    [_aboutButton setTitleColor:COLOR_STRING(@"#444444") forState:UIControlStateNormal];
    [_aboutButton addTarget:self action:@selector(aboutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _aboutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_myScrollView addSubview: _aboutButton];
    
    _myScrollView.contentSize = CGSizeMake(_bottomView.frame.size.width,_aboutButton.frame.origin.y + 40);
    
    
    _exitButton = [[UIButton alloc] initWithFrame:CGRectMake(20,self.frame.size.height - 45, _aboutButton.frame.size.width, 50)];
    [_exitButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [_exitButton.titleLabel setFont:MY_FONT(14)];
    [_exitButton setTitleColor:COLOR_STRING(@"#666666") forState:UIControlStateNormal];
    [_exitButton addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _exitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview: _exitButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(120,self.frame.size.height - 30, 20, 20)];
//    imageView.userInteractionEnabled = YES;
//    imageView.backgroundColor = [UIColor lightGrayColor];
    [imageView setImage:[UIImage imageNamed:@"登录退出"]];
    [self addSubview:imageView];
    imageView.hidden = YES;
    
    _babyButton.hidden = NO;
    _memberButton.hidden = YES;
    _deviceButton.hidden = NO;
    _shopDeviceButton.hidden = YES;
    _commonIssueButton.hidden = YES;
    _coupleBackButton.hidden = NO;
    _aboutButton.hidden = NO;
    
//    _aboutButton.frame = _deviceButton.frame;
//    _deviceButton.frame = _babyButton.frame;
//    _coupleBackButton.frame = _memberButton.frame;
    
    _aboutButton.frame = _shopDeviceButton.frame;
    _coupleBackButton.frame = _deviceButton.frame;
    _deviceButton.frame = _memberButton.frame;
    
    self.versionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_aboutButton.frame.origin.x + 60, _aboutButton.frame.origin.y + 15, 20, 25) ];
    [self.versionImageView setImage:[UIImage imageNamed:@"小布壳_推荐升级_版本提示"]];
    [_myScrollView addSubview: self.versionImageView];
    self.versionImageView.hidden = YES;
    
//    _exitImageView = [[UIButton alloc] initWithFrame:CGRectMake(20,self.frame.size.height - 45, _aboutButton.frame.size.width, 40)];
//    [_exitButton setTitle:@"退出登录/关闭" forState:UIControlStateNormal];
//    [_exitButton.titleLabel setFont:MY_FONT(14)];
//    [_exitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_exitButton addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    _exitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [self addSubview: _exitButton];
    
    
}

-(void) updateVersion
{
    if (APP_DELEGATE.mVersionInfo != nil) {
        self.versionImageView.hidden = NO;
    }
}

-(void)clickUserInfo:(id)sender
{
    NSLog(@"用户信息");
    [self.customDelegate LeftMenuViewClick:0];
}

-(IBAction)babyButtonClick:(id)sender
{
    NSLog(@"宝贝信息");
    [self.customDelegate LeftMenuViewClick:1];
}

-(IBAction)memberButtonClick:(id)sender
{
    NSLog(@"成员管理");
    [self.customDelegate LeftMenuViewClick:2];
}

-(IBAction)deviceButtonClick:(id)sender
{
    NSLog(@"设备管理");
    [self.customDelegate LeftMenuViewClick:3];
}

-(IBAction)shopDeviceButtonClick:(id)sender
{
    NSLog(@"购买设备");
    [self.customDelegate LeftMenuViewClick:4];
}

-(IBAction)commonIssueButtonClick:(id)sender
{
    NSLog(@"在线帮助");
    [self.customDelegate LeftMenuViewClick:5];
}

-(IBAction)feedbackClick:(id)sender
{
    NSLog(@"意见反馈");
    [self.customDelegate LeftMenuViewClick:6];
}

-(IBAction)aboutButtonClick:(id)sender
{
    NSLog(@"关于");
    [self.customDelegate LeftMenuViewClick:7];
}

-(IBAction)exitButtonClick:(id)sender
{
    NSLog(@"退出登录/关闭");
    [self.customDelegate LeftMenuViewClick:8];
}



//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return imgView;
//}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did end decelerating");
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"Did scroll");
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
    NSLog(@"Did end dragging");
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did begin decelerating");
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"Did begin dragging");
}

-(void)setImageUlr:(NSString *)imageUlr
{
    _imageUlr = imageUlr;
    if (imageUlr != nil && imageUlr.length != 0) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[imageUlr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@""]];
    }else{
        _headImageView.image = [UIImage imageNamed:@"children"];
    }
}

-(void)setAppellativeName:(NSString *)appellativeName
{
    _appellativeName = appellativeName;
    _signatureLabel.text = appellativeName ? : @"";

}

@end
