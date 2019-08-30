//
//  TalkNotificationNav.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TalkNotificationNav_Event @"TalkNotificationNav_Event"
NS_ASSUME_NONNULL_BEGIN

@interface TalkNotificationNav : UIView
@property(nonatomic,strong)UIView *linview;
-(void)animationTo:(NSInteger)index;
-(void)setNotifactionBadge:(BOOL)hidden;
-(void)setTalkBadge:(BOOL)hidden;
-(BOOL)GetTalkBadgeIsHide;
-(void)animationWithOffset:(CGFloat)offset;
@end

NS_ASSUME_NONNULL_END
