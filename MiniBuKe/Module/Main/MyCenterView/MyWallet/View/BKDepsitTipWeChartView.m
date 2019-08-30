//
//  BKDepsitTipWeChartView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKDepsitTipWeChartView.h"
@interface BKDepsitTipWeChartView()

@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UIImageView *iconWeChartView;
@property (nonatomic, weak) IBOutlet UIButton *btn;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *titlelabel;

@end
@implementation BKDepsitTipWeChartView
- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKDepsitTipWeChartView" owner:nil options:nil] lastObject];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 233);
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.btn.backgroundColor = COLOR_STRING(@"#FEA449");
    self.btn.clipsToBounds = YES;
    self.btn.layer.cornerRadius = 22.f;
    self.iconWeChartView.hidden = YES;
    self.iconView.layer.cornerRadius = 30.f;
    self.iconView.clipsToBounds = YES;
    self.iconWeChartView.backgroundColor = [UIColor whiteColor];
    self.iconWeChartView.layer.cornerRadius = 9.f;
    self.iconWeChartView.layer.borderWidth = 1;
    self.iconWeChartView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconWeChartView.clipsToBounds = YES;
}

- (void)setUIWithImageUrl:(NSString*)url andNameStr:(NSString*)nameStr andTitleStr:(NSString*)titleStr andBtnStr:(NSString*)btnStr{
    if (url.length) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image != nil) {
                self.iconWeChartView.hidden = NO;
            }
        }];
    }else{
        self.iconView.image = [UIImage imageNamed:@"login_wechart_icon"];
        self.iconWeChartView.hidden = YES;
    }
    
    self.nameLabel.text = nameStr;
    self.titlelabel.text = titleStr;
    
    [self.btn setTitle:btnStr forState:UIControlStateNormal];
    [self.btn setTitleColor:COLOR_STRING(@"ffffff") forState:UIControlStateNormal];
}

- (IBAction)btnClick:(id)sender{
    if (_ClickDoneBtn) {
        _ClickDoneBtn();
    }
}
@end
