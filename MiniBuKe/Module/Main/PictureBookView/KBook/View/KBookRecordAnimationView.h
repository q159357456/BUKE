//
//  KBookRecordAnimationView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/6/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KBookRecordAnimationView : UIView

@property (nonatomic, copy) void (^itemLevelCallback)(void);

@property (nonatomic) NSUInteger numberOfItems;

@property (nonatomic) UIColor * itemColor;

@property (nonatomic) CGFloat level;

@property (nonatomic) UILabel *timeLabel;

@property (nonatomic) NSString *text;

@property (nonatomic) CGFloat middleInterval;

- (void)start;
- (void)stop;



@end
