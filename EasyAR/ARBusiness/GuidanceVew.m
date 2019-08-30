//
//  GuidanceVew.m
//  MiniBuKe
//
//  Created by chenheng on 2019/5/13.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "GuidanceVew.h"
#import "GCCycleScrollView.h"
@interface GuidanceVew ()<GCCycleScrollViewDelegate>
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UIButton *doneButton;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,strong)UILabel * describLabel;
@property(nonatomic,assign)NSInteger timeNum;
@property(nonatomic,strong)UIButton * buyBtn;
@property(nonatomic,copy)void(^DoneBlock)(NSInteger index);
@end
@implementation GuidanceVew

+(instancetype)showGuidInfo:(NSArray*)imageList Describ:(NSString*)describ CallBack:(void(^)(NSInteger index))block;
{
    GuidanceVew *guid = [[GuidanceVew alloc]init:imageList Describ:describ];
    guid.DoneBlock = ^(NSInteger index) {
        block(index);
    };
    return guid;
}
-(instancetype)init:(NSArray*)imageList Describ:(NSString*)describ
{
    if (self = [super init]) {
        self.frame = APP_DELEGATE.window.bounds;
        self.backgroundColor =  A_COLOR_STRING(0x191919, 0.8f);
        UIView *contenView = [[UIView alloc]init];
        self.contentView = contenView;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 24;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
        
        UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"ar_lock_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(close1) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(300, 439));
        }];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_top).offset(-5);
            make.left.mas_equalTo(self.contentView.mas_right);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        GCCycleScrollView *cycleScroll = [[GCCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 208)];
        cycleScroll.localImageGroups = imageList;
        cycleScroll.autoScrollTimeInterval = 3.5;
        cycleScroll.dotColor = COLOR_STRING(@"#5FBF82");
        cycleScroll.pageControlAliment = GCCycleScrollPageControlAlimentRight;
        cycleScroll.delegate = self;
        [self.contentView addSubview:cycleScroll];
//        CGFloat scroW = 300;
//        CGFloat scroH = 208;
//        UIScrollView *cycleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scroW,scroH)];
//        cycleScroll.backgroundColor = COLOR_STRING(@"#C0914E");
//        [self.contentView addSubview:cycleScroll];
//
        UIView *pageView = [[UIView alloc]init];
        pageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:pageView];
        
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = @"使用说明";
        UILabel *label2 = [[UILabel alloc]init];
        label2.numberOfLines = 0;
        label2.font = [UIFont systemFontOfSize:12];
        label2.textColor = [UIColor lightGrayColor];
        label2.text = @"第1步：点击扫码激活跳转扫码页面后，对准会员卡二维码扫码即可";
        self.describLabel = label2;
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneButton setBackgroundColor:COLOR_STRING(@"#F6922D")];
        [self.doneButton setTitle:@"扫码激活" forState:UIControlStateNormal];
        self.doneButton.layer.cornerRadius = 22;
        self.doneButton.layer.masksToBounds = YES;
        [self.doneButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        
        self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.buyBtn setTitleColor:COLOR_STRING(@"#999999") forState:UIControlStateNormal];
        self.buyBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:@"或开通会员"];
        [attributeString addAttribute:NSUnderlineStyleAttributeName
                                value:@(NSUnderlineStyleSingle)
                                range:(NSRange){0,[attributeString length]}];
        //此时如果设置字体颜色要这样
        [attributeString addAttribute:NSForegroundColorAttributeName value:COLOR_STRING(@"#999999")  range:NSMakeRange(0,[attributeString length])];
        [self.buyBtn addTarget:self action:@selector(buyMember) forControlEvents:UIControlEventTouchUpInside];
        
        //设置下划线颜色...
        [attributeString addAttribute:NSUnderlineColorAttributeName value:COLOR_STRING(@"#999999") range:(NSRange){0,[attributeString length]}];
        [self.buyBtn setAttributedTitle:attributeString forState:UIControlStateNormal];
        self.buyBtn.hidden = YES;
        [self.contentView addSubview:label1];
        [self.contentView addSubview:label2];
        [self.contentView addSubview:self.doneButton];
        [self.contentView addSubview:self.buyBtn];
    
        [cycleScroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(208);
        }];
        
        [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cycleScroll.mas_bottom);
            make.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(50);
            
        }];
        
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(35);
            make.top.mas_equalTo(pageView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(80, 17));
        }];
        
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(self.contentView).offset(35);
           make.right.mas_equalTo(self.contentView).offset(-35);
           make.top.mas_equalTo(label1.mas_bottom).offset(21);
           make.height.mas_equalTo(35);
            
        }];
        
        [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-44);
            make.centerX.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(200 , 44));
        }];
        [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
            make.centerX.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(200 , 15));
        }];
        
        //set scroview pageView
//        cycleScroll.contentSize = CGSizeMake(scroW * imageList.count, scroH);
//        for (NSInteger i = 0; i<imageList.count; i++) {
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(scroW*i, 0, scroW, scroH)];
//            imageView.image = imageList[i];
//            [cycleScroll addSubview:imageView];
//        }
        self.timeNum = 1;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
        
    }
    return self;
}
-(void)showBuyMember:(BOOL)is
{
    self.buyBtn.hidden = !is;
}
-(void)close{
    self.DoneBlock(0);
    [self.timer invalidate];
    [self removeFromSuperview];
   
}
-(void)close1{
    [self.timer invalidate];
    [self removeFromSuperview];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.timer.valid) {
        self.timeNum = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
        self.describLabel.text = @"第1步：点击扫码激活跳转扫码页面后，对准会员卡二维码扫码即可";
    }
    
}
-(void)removeFromSuperview{
     [self.timer invalidate];
    [super removeFromSuperview];
}
#pragma mark - GCCycleScrollViewDelegate
- (void)cycleScrollView:(GCCycleScrollView *)cycleScrollView didSelectItemAtRow:(NSInteger)row {
    NSLog(@"row===>%ld",row);
    
}

-(void)updateLabel{
    NSLog(@"self.timeNum==>%ld",self.timeNum);
    self.timeNum++;
    if (self.timeNum % 3 == 1) {
        self.describLabel.text = @"第1步：点击扫码激活跳转扫码页面后，对准会员卡二维码扫码即可";
        
    }else if(self.timeNum % 3 == 2){
        self.describLabel.text = @"第2步：将手机插入底座，并将伴读反光镜 戴在手机前置摄像头的位置";
    }else
    {
        self.describLabel.text = @"第3步：调高手机音量";
    }
    

}
-(void)buyMember{
    self.DoneBlock(1);
    [self.timer invalidate];
    [self removeFromSuperview];
}

-(void)dealloc
{
     [self.timer invalidate];
}


@end


