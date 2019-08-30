//
//  BindMaskViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BindMaskViewController.h"
#import "PrepareConfigNetViewController.h"

@interface BindMaskViewController ()

@end

@interface BindMaskViewController ()

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@end

@implementation BindMaskViewController

+(void) pushViewController
{
//    BindMaskViewController *mBindMaskViewController = [[BindMaskViewController alloc] init];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mBindMaskViewController];
//    [APP_DELEGATE.navigationController presentModalViewController:navigationController animated:YES];
    BindMaskViewController *mBindMaskViewController = [[BindMaskViewController alloc] init];
    [APP_DELEGATE.navigationController pushViewController:mBindMaskViewController animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:COLOR_STRING(@"#EEE8E6")];
    
    [self initView];
}

- (void)initView{
    _topView = [[UIView alloc] init];
//    [_topView setBackgroundColor:COLOR_STRING(@"#FF5001")];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];

    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] init];
    [self.view addSubview:_bottomView];
    
    _middleView = [[UIView alloc] init];
    [_middleView setBackgroundColor:COLOR_STRING(@"#F0EDEB")];
    [self.view addSubview:_middleView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 73));
        make.top.equalTo(self.view);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 0));
        make.top.equalTo(self.view).with.offset(self.view.frame.size.height - 0);
        make.bottom.equalTo(self.view);
    }];
    
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(_bottomView.mas_top);
        //make.top.equalTo(_topView.mas_height);
    }];
    
    [self createTopViewChild];
    [self createMiddleViewChild];
}

-(void) createMiddleViewChild
{
    UIImageView *tipImageView = [[UIImageView alloc] init];
    tipImageView.frame = CGRectMake(SCREEN_WIDTH - 237 - 25, 38, 237, 182);
    tipImageView.image = [UIImage imageNamed:@"binding_q1_pop"];
    [self.middleView addSubview:tipImageView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, tipImageView.frame.size.width - 30*2, 20)];
    label1.text = @"哎呀,这个功能需要绑定";
    label1.font = MY_FONT(14);
    label1.textColor = COLOR_STRING(@"#666666");
    label1.textAlignment = NSTextAlignmentCenter;
    [tipImageView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y + label1.frame.size.height + 5, label1.frame.size.width, label1.frame.size.height)];
    label2.textColor = COLOR_STRING(@"#5B5B5B");
    label2.font = MY_FONT(14);
    label2.text = @"小布壳机器人才能使用哦!";
    label2.textAlignment = NSTextAlignmentCenter;
    [tipImageView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, label2.frame.origin.y + label2.frame.size.height + 5, label1.frame.size.width, label1.frame.size.height)];
    label3.textAlignment = NSTextAlignmentRight;
    label3.textColor = COLOR_STRING(@"#999999");
    label3.font = MY_FONT(13);
    label3.text = @"了解更多 >";
    [tipImageView addSubview:label3];
    
    //label3 可以点击暂时没有跳转,隐藏
    label3.hidden = YES;
    
    UIImageView *xiaobukeImageView = [[UIImageView alloc] init];
    xiaobukeImageView.frame = CGRectMake((SCREEN_WIDTH - 280)*0.5, 206, 280, 257);
    xiaobukeImageView.image = [UIImage imageNamed:@"binding_q1_xiaobuke1"];
    [self.middleView addSubview:xiaobukeImageView];
    
    
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //适配iphone5/se
    if (is_IPhone5) {
        downButton.frame = CGRectMake(16, self.view.frame.size.height - 35 - 10, self.view.frame.size.width - 16*2, 35);
    }else{
        downButton.frame = CGRectMake(16, self.view.frame.size.height - 60 - 43, self.view.frame.size.width - 16*2, 43);
    }
    
    [downButton setBackgroundColor:COLOR_STRING(@"#FF721C")];
    [downButton setTitle:@"绑定设备" forState:UIControlStateNormal];
    [downButton.titleLabel setFont:MY_FONT(18)];
    downButton.layer.cornerRadius = 7;
    downButton.layer.borderColor = COLOR_STRING(@"FF721C").CGColor;
    downButton.layer.masksToBounds = YES;
    
    [downButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downButton];
}

-(IBAction)downButtonClick:(id)sender{
    NSLog(@"下一步");
    PrepareConfigNetViewController *wifiVC = [[PrepareConfigNetViewController alloc] init];
    [self.navigationController pushViewController:wifiVC animated:YES];
}

-(void) createTopViewChild {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    
    //[_moveButton setTitle:@"故事" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    //[_moveButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"绑定说明";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2F2F2F");
    [_topView addSubview: titleLabel];
}

-(IBAction)backButtonClick:(id)sender
{
//    [APP_DELEGATE.navigationController dismissModalViewControllerAnimated:YES];
    [APP_DELEGATE.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
}

- (void)hideBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    
    //self.view.backgroundColor = [UIColor redColor];
}

- (void)showBarStyle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
}

@end
