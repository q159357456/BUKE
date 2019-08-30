//
//  BKCenterDeviceCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCenterDeviceCell.h"

@implementation BKCenterDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.text = @"去绑定";
        _label.font = [UIFont systemFontOfSize:15];
 
    }
    return _label;
}

-(void)DeviceReload{
    if(APP_DELEGATE.mLoginResult.SN == nil || APP_DELEGATE.mLoginResult.SN.length == 0)
    {
        self.titleImageView.hidden = YES;
        self.label1.hidden = YES;
        self.label2.hidden = YES;
        self.label.hidden = NO;
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100, 17));
            make.left.mas_equalTo(self.mas_left).offset(15);
        }];
        
    }else
    {
        self.titleImageView.hidden = NO;
        self.label1.hidden = NO;
        self.label2.hidden = NO;
        self.label.hidden = YES;
        //        NSLog(@"PP_DELEGATE.isOnLine:%d",APP_DELEGATE.isOnLine);
        if (APP_DELEGATE.isOnLine) {
            if(4 == [APP_DELEGATE.snData.type integerValue]){
                self.label2.text = @"在线";
            }else{
                self.label2.text = @"已联网";
            }
            
            if (APP_DELEGATE.snData.wifiImg.length) {
                [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:APP_DELEGATE.snData.wifiImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                }];
            }else{
//                self.titleImageView.image = [UIImage imageNamed:@"networking_icon"];
            }

        }else
        {
            if(4 == [APP_DELEGATE.snData.type integerValue]){
                self.label2.text = @"离线";

            }else{
                
                self.label2.text = @"未连接";
            }

            if (APP_DELEGATE.snData.unWifiImg.length) {
                [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:APP_DELEGATE.snData.unWifiImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                }];
            }else{
//                self.titleImageView.image = [UIImage imageNamed:@"networking_false_icon"];
            }
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
