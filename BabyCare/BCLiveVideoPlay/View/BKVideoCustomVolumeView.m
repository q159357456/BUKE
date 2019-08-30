//
//  BKVideoCustomVolumeView.m
//  babycaretest
//
//  Created by Don on 2019/4/25.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKVideoCustomVolumeView.h"
#import "Masonry.h"

@interface BKVideoCustomVolumeView()

@property (strong, nonatomic) UIImageView *icon;
@property (nonatomic, assign) NSInteger type;
@property (strong, nonatomic) UIProgressView *volumeProgress;

@end

@implementation BKVideoCustomVolumeView

- (instancetype)initWithVolumeOrLight:(NSInteger)type{
    if (self = [super init]) {
        self.type = type;
        [self setupUI];
    }
    return  self;
}

- (void)setupUI{
    
    self.icon = [[UIImageView alloc]init];
    if (self.type == 0) {
        self.icon.image = [UIImage imageNamed:@"bc_voice_more_icon"];
    }else{
        self.icon.image = [UIImage imageNamed:@"bc_bright_more_icon"];
    }
    [self addSubview:self.icon];
    
    self.volumeProgress = [[UIProgressView alloc]init];
    self.volumeProgress.progressTintColor    = [UIColor colorWithRed:114/255.0 green:197/255.0 blue:137/255.0 alpha:1.0];
    self.volumeProgress.trackTintColor       = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    self.volumeProgress.trackTintColor       = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    [self addSubview:self.volumeProgress];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;

    if (self.type == 0) {
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(13);
            make.centerY.equalTo(weakSelf.mas_centerY).offset(0);
            make.left.equalTo(weakSelf.mas_left).offset(14);
        }];

    }else{
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
            make.centerY.equalTo(weakSelf.mas_centerY).offset(0);
            make.left.equalTo(weakSelf.mas_left).offset(14);
        }];

    }
    [self.volumeProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(0);
        make.left.equalTo(weakSelf.icon.mas_right).offset(6);
        make.right.equalTo(weakSelf.mas_right).offset(-14);
    }];

}

- (void)changeTheProgress:(CGFloat)value{
    if (self.type == 0) {//音量
        if (value>0.3) {
            self.icon.image = [UIImage imageNamed:@"bc_voice_more_icon"];
        }else if (value > 0){
            self.icon.image = [UIImage imageNamed:@"bc_voice_less_icon"];
        }else{
            self.icon.image = [UIImage imageNamed:@"bc_voice_quite_icon"];
        }
    }else{//亮度
        if (value>0.3) {
            self.icon.image = [UIImage imageNamed:@"bc_bright_more_icon"];

        }else{
            self.icon.image = [UIImage imageNamed:@"bc_bright_less_icon"];
        }
    }
    [self.volumeProgress setProgress:value animated:YES];
}

@end
