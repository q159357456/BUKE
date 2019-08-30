//
//  BKVideoCustomVolumeView.h
//  babycaretest
//
//  Created by Don on 2019/4/25.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//
//自定义音量条
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKVideoCustomVolumeView : UIView

- (instancetype)initWithVolumeOrLight:(NSInteger)type;

- (void)changeTheProgress:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
