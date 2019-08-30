//
//  BKHomePopView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKHomePopView.h"

@interface BKHomePopView()
@property (nonatomic, weak) IBOutlet UIButton *actionBtn;
@property (nonatomic,strong) IBOutlet UILabel *title;
@property (nonatomic,strong) IBOutlet UILabel *subtitle;
@property (nonatomic,strong) IBOutlet UITextView *contentTextView;
@property (nonatomic,strong) IBOutlet UIImageView *topImage;
@property (nonatomic,strong) IBOutlet UIImageView *bgImage;
@property (nonatomic,strong) IBOutlet UIImageView *overspreadImage;

@end

@implementation BKHomePopView

- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKHomePopView" owner:nil options:nil] lastObject];
        self.frame = CGRectMake(0, 0, (300/375.0)*SCREEN_WIDTH,(360/300.0)*(300/375.0)*SCREEN_WIDTH);
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.actionBtn.layer.cornerRadius = 22.f;
    self.actionBtn.clipsToBounds = YES;
    
    self.layer.cornerRadius = 24.f;
    self.clipsToBounds = YES;
    self.contentTextView.showsVerticalScrollIndicator = YES;
    self.contentTextView.editable = NO;
    self.bgImage.contentMode = UIViewContentModeScaleToFill;
}

- (IBAction)btnClick:(id)sender{
    if (self.BtnClick) {
        self.BtnClick();
    }
}

-(void)setUpTitle:(NSString*)titleStr andsubTitle:(NSString*)subTitle andBtntitel:(NSString*)btnTitle andImageName:(NSString*)imageName andContent:(NSString*)content andIsFullPic:(BOOL)isFullPic{
    
    if (btnTitle.length) {
        [self.actionBtn setTitle:btnTitle forState:UIControlStateNormal];
        [self.actionBtn setTitleColor:COLOR_STRING(@"#ffffff") forState:UIControlStateNormal];
    }
    if (isFullPic) {//全图样式
        self.backgroundColor = [UIColor clearColor];
        if (imageName.length) {
            if ([imageName hasPrefix:@"http"]) {
                [self.bgImage sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil options:SDWebImageRetryFailed];
            }else{
                self.bgImage.image= [UIImage imageNamed:imageName];
            }
        }
        self.title.hidden = YES;
        self.subtitle.hidden = YES;
        self.contentTextView.hidden = YES;
        self.topImage.hidden = YES;
        self.overspreadImage.hidden = YES;
    }else{
        self.backgroundColor = [UIColor whiteColor];

        self.title.hidden = NO;
        self.subtitle.hidden = NO;
        self.contentTextView.hidden = NO;
        self.topImage.hidden = NO;
        self.overspreadImage.hidden = NO;
        
        if (titleStr.length) {
            self.title.text = titleStr;
        }
        if (subTitle.length) {
            self.subtitle.text = subTitle;
        }
        if (content.length) {
            self.contentTextView.text = content;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 3;// 字体的行间距
            paragraphStyle.headIndent = 12;
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:13],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            self.contentTextView.attributedText = [[NSAttributedString alloc] initWithString:content attributes:attributes];
        }
        if (imageName.length) {
            if ([imageName hasPrefix:@"http"]) {
                [self.topImage sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil options:SDWebImageRetryFailed];
            }else{
                self.topImage.image = [UIImage imageNamed:imageName];
            }
        }

    }
}
@end
