//
//  BKCenterConnect.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCenterConnect.h"

@implementation BKCenterConnect

- (void)awakeFromNib {
    [super awakeFromNib];
  
    // Initialization code
}
-(void)DeviceReload{
    
    if(APP_DELEGATE.mLoginResult.SN == nil || APP_DELEGATE.mLoginResult.SN.length == 0)
    {
        self.dianL.hidden = YES;
        self.batteryView.hidden = YES;
    }else
    {
        self.dianL.hidden = NO;
        self.batteryView.hidden = NO;
        self.dianL.text = [NSString stringWithFormat:@"%.0f%%",APP_DELEGATE.ElectricQuantity].length?[NSString stringWithFormat:@"%.0f%%",APP_DELEGATE.ElectricQuantity]:@"";
        if (APP_DELEGATE.ElectricQuantity) {
            self.batteryView.electricQuantity = APP_DELEGATE.ElectricQuantity;
        }
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
