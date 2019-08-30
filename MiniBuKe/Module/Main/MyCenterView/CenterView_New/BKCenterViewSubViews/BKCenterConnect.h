//
//  BKCenterConnect.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BatteryView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BKCenterConnect : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *dianL;
@property (weak, nonatomic) IBOutlet BatteryView *batteryView;
-(void)DeviceReload;
@end

NS_ASSUME_NONNULL_END
