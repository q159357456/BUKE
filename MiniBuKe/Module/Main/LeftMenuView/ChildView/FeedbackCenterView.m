//
//  FeedbackCenterView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "FeedbackCenterView.h"
#import "FOFPlaceholderTextView.h"
#import "PutFeedBackService.h"
#import "MBProgressHUD+XBK.h"

@interface FeedbackCenterView ()<FOFPlaceholderTextViewDelegate>

@property (nonatomic,strong) IBOutlet FOFPlaceholderTextView *mFOFPlaceholderTextView;
@property (nonatomic,strong) IBOutlet UILabel *showInputTextCountLabel;
@property (nonatomic,strong) IBOutlet UIButton *commitButton;

@property (nonatomic,strong) IBOutlet UIImageView *imageview1;
@property (nonatomic,strong) IBOutlet UIImageView *imageview2;
@property (nonatomic,strong) IBOutlet UIImageView *imageview3;
@property (nonatomic,strong) IBOutlet UIImageView *imageview4;
@property (nonatomic,strong) IBOutlet UIImageView *imageview5;
@property (nonatomic,strong) IBOutlet UIImageView *imageview6;

@property (nonatomic,strong) IBOutlet UIView *view1;
@property (nonatomic,strong) IBOutlet UIView *view2;

@property (nonatomic) BOOL isSelect1;
@property (nonatomic) BOOL isSelect2;
@property (nonatomic) BOOL isSelect3;
@property (nonatomic) BOOL isSelect4;
@property (nonatomic) BOOL isSelect5;
@property (nonatomic) BOOL isSelect6;

@end

@implementation FeedbackCenterView

+(instancetype)xibView {
    FeedbackCenterView *view = [[[NSBundle mainBundle] loadNibNamed:@"FeedbackCenterView" owner:nil options:nil] lastObject];
    [view setBackgroundColor:COLOR_STRING(@"#EBEBEB")];
    //[view updateView];
    return view;
}

-(void) updateView:(CGSize) size
{
    NSLog(@"size ===> %f",size.width);
    
    UIView *view1Behind = [[UIView alloc] initWithFrame:CGRectMake(self.view1.frame.origin.x, self.view1.frame.origin.y, size.width, self.view1.frame.size.height)];
    view1Behind.backgroundColor = [UIColor whiteColor];
    [self addSubview: view1Behind];
    self.view1.frame = CGRectMake((size.width - self.view1.frame.size.width) / 2, self.view1.frame.origin.y, self.view1.frame.size.width, self.view1.frame.size.height);
    [self sendSubviewToBack:view1Behind];
    [self bringSubviewToFront:self.view1];
    
    UIView *view2Behind = [[UIView alloc] initWithFrame:CGRectMake(self.view2.frame.origin.x, self.view2.frame.origin.y, size.width, self.view2.frame.size.height)];
    view2Behind.backgroundColor = [UIColor whiteColor];
    [self addSubview: view2Behind];
    self.view2.frame = CGRectMake((size.width - self.view2.frame.size.width) / 2, self.view2.frame.origin.y, self.view2.frame.size.width, self.view2.frame.size.height);
    [self sendSubviewToBack:view2Behind];
    [self bringSubviewToFront:self.view2];
    
    self.commitButton.frame = CGRectMake(15, self.commitButton.frame.origin.y, size.width - 30, self.commitButton.frame.size.height);
    
    if (size.width > 375) {
        self.showInputTextCountLabel.frame = CGRectMake(self.showInputTextCountLabel.frame.origin.x + 25, self.showInputTextCountLabel.frame.origin.y, self.showInputTextCountLabel.frame.size.width, self.showInputTextCountLabel.frame.size.height);
    }
    
    self.mFOFPlaceholderTextView.fofDelegate = self;
    self.mFOFPlaceholderTextView.returnKeyType = UIReturnKeyDone;
    self.commitButton.userInteractionEnabled = NO;
    
    [self.commitButton.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.commitButton.layer setBorderWidth:1.0f];
    [self.commitButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    //边框宽度
    [self.commitButton.layer setBorderWidth:1.0];
    [self.commitButton.layer setMasksToBounds:YES];
    
    self.isSelect1 = NO;
    self.isSelect2 = NO;
    self.isSelect3 = NO;
    self.isSelect4 = NO;
    self.isSelect5 = NO;
    self.isSelect6 = NO;
    
    
    
}

- (BOOL)placeholderTextView:(FOFPlaceholderTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSLog(@"===> placeholderTextView ==> %i ==>%i ==>%i",range.length,text.length,self.mFOFPlaceholderTextView.text.length - range.length);
    return YES;
}

-(void)placeholderTextViewDidChange:(FOFPlaceholderTextView *)textView
{
    NSLog(@"===> %i",self.mFOFPlaceholderTextView.text.length);
    self.showInputTextCountLabel.text = [NSString stringWithFormat:@"%i/500",self.mFOFPlaceholderTextView.text.length];
    if (self.mFOFPlaceholderTextView.text.length <= 0) {
        [self.commitButton setBackgroundColor:COLOR_STRING(@"#AAAAAA")];
        self.commitButton.userInteractionEnabled = NO;
    } else {
        [self.commitButton setBackgroundColor:COLOR_STRING(@"#FF7232")];
        self.commitButton.userInteractionEnabled = YES;
    }
}

-(void)placeholderTextViewDidOverMax:(FOFPlaceholderTextView *)textView
{
    
}

-(IBAction) onClickCommitButton:(id)sender
{
    NSLog(@"===> onClickCommitButton <===");
    
    NSString *infoType = [self getStringOfOptionsForFeedBack];
    NSString *infoContent = self.mFOFPlaceholderTextView.text;
    NSLog(@"str ==> %@ = %@",infoType,infoContent);
    
    if (infoType.length > 0) {
        [self onPutFeedBackService:infoType setInfoContent:infoContent];
    } else {
        [MBProgressHUD showText:@"请选择问题类型，再提交哈"];
    }
}

-(void)onPutFeedBackService:(NSString *) infoType setInfoContent: infoContent
{
    [MBProgressHUD showMessage:@"加载中..."];
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"PutFeedBackService ==> OnSuccess");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"亲，我们已收到您的反馈！"];
        if (self.delegate != nil) {
            [self.delegate onSubmit];
        }
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"PutFeedBackService ==> OnError");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:description];
    };
    
    PutFeedBackService *service = [[PutFeedBackService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setInfoContent:infoContent setInfoType:infoType];
    [service start];
}

-(NSString *) getStringOfOptionsForFeedBack
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (self.isSelect1) {
        [array addObject:@"缺书登记"];
    }
    if (self.isSelect2) {
        [array addObject:@"绘本功能"];
    }
    if (self.isSelect3) {
        [array addObject:@"小布壳机器人"];
    }
    if (self.isSelect4) {
        [array addObject:@"配置网络"];
    }
    if (self.isSelect5) {
        [array addObject:@"听听功能"];
    }
    if (self.isSelect6) {
        [array addObject:@"其它"];
    }
    NSString *str = @"";
    if (array != nil && array.count > 0) {
        for (int i = 0; i < array.count; i ++) {
            NSString *temp = [array objectAtIndex: i];
            if (i != 0) {
                str = [NSString stringWithFormat:@"%@,%@",str,temp];
            } else {
                str = temp;
            }
        }
    }
    return str;
}

-(IBAction) onClickNetWorkSettingButton:(id)sender
{
    NSLog(@"===> onClickNetWorkSettingButton <===");
    if (self.isSelect1) {
        self.isSelect1 = NO;
        [self.imageview1 setImage: [UIImage imageNamed:@"复选框_NO"]];
    } else {
        self.isSelect1 = YES;
        [self.imageview1 setImage: [UIImage imageNamed:@"复选框_YES"]];
    }
    
}

-(IBAction) onClickBookFunctionButton:(id)sender
{
    NSLog(@"===> onClickBookFunctionButton <===");
    if (self.isSelect2) {
        self.isSelect2 = NO;
        [self.imageview2 setImage: [UIImage imageNamed:@"复选框_NO"]];
    } else {
        self.isSelect2 = YES;
        [self.imageview2 setImage: [UIImage imageNamed:@"复选框_YES"]];
    }
}

-(IBAction) onClickFunctionButton:(id)sender
{
    NSLog(@"===> onClickFunctionButton <===");
    if (self.isSelect3) {
        self.isSelect3 = NO;
        [self.imageview3 setImage: [UIImage imageNamed:@"复选框_NO"]];
    } else {
        self.isSelect3 = YES;
        [self.imageview3 setImage: [UIImage imageNamed:@"复选框_YES"]];
    }
}

-(IBAction) onClickPictureBookFunctionButton:(id)sender
{
    NSLog(@"===> onClickPictureBookFunctionButton <===");
    if (self.isSelect4) {
        self.isSelect4 = NO;
        [self.imageview4 setImage: [UIImage imageNamed:@"复选框_NO"]];
    } else {
        self.isSelect4 = YES;
        [self.imageview4 setImage: [UIImage imageNamed:@"复选框_YES"]];
    }
}

-(IBAction) onClickListenFunctionButton:(id)sender
{
    NSLog(@"===> onClickListenFunctionButton <===");
    if (self.isSelect5) {
        self.isSelect5 = NO;
        [self.imageview5 setImage: [UIImage imageNamed:@"复选框_NO"]];
    } else {
        self.isSelect5 = YES;
        [self.imageview5 setImage: [UIImage imageNamed:@"复选框_YES"]];
    }
}

-(IBAction) onClickOtherButton:(id)sender
{
    NSLog(@"===> onClickOtherButton <===");
    if (self.isSelect6) {
        self.isSelect6 = NO;
        [self.imageview6 setImage: [UIImage imageNamed:@"复选框_NO"]];
    } else {
        self.isSelect6 = YES;
        [self.imageview6 setImage: [UIImage imageNamed:@"复选框_YES"]];
    }
}

@end
