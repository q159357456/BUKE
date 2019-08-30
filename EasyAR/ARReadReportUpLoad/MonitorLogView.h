//
//  MonitorLogView.h
//  MiniBuKe
//
//  Created by chenheng on 2019/7/5.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonitorLogView : UIView
+(instancetype)singleton;
+(void)showMonitorLog:(NSString*)Log ;
+(void)hiddenMonitorLog;
@property(nonatomic,copy)NSString * content;
@end

NS_ASSUME_NONNULL_END
