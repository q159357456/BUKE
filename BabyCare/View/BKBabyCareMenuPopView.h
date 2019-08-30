//
//  BKBabyCareMenuPopView.h
//  MiniBuKe
//
//  Created by chenheng on 2019/4/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BKBabyCareMenuPopViewDelegate <NSObject>

- (void)BCMenuPopBtnClick:(NSInteger)index;

@end

@interface BKBabyCareMenuPopView : UIView

@property(nonatomic, weak) id <BKBabyCareMenuPopViewDelegate> delegate;

-(instancetype)initWithPopLocation:(CGPoint)point;
- (void)startAnimation;

@end

NS_ASSUME_NONNULL_END
