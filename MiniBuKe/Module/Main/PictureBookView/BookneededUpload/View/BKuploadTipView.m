//
//  BKuploadTipView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/15.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKuploadTipView.h"

@interface BKuploadTipView()

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *desLabel;
@property (nonatomic, weak) IBOutlet UIButton *leftBtn;
@property (nonatomic, weak) IBOutlet UIButton *rightBtn;

@end

@implementation BKuploadTipView

- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKuploadTipView" owner:nil options:nil] lastObject];
        self.frame = CGRectMake(0, 0, 300, 270);
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 22.f;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setTitle:(NSString*)title des:(NSString*)des andImage:(NSString*)iconstr andLeftBtnTitle:(NSString*)leftTitle andRightBtnTitle:(NSString*)rightTitle{
    self.iconImageView.image = [UIImage imageNamed:iconstr];
    self.titleLabel.text = title;
    self.desLabel.text = des;
    self.titleLabel.textColor = COLOR_STRING(@"#999999");
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
}

- (IBAction)leftBtnAction:(id)sender{
    _leftBtnClick();

}
- (IBAction)rightBtnAction:(id)sender{
    _rightBtnClick();
}

@end
