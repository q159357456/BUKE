//
//  FeedbackCenterView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedbackCenterViewDelegate <NSObject>

-(void) onSubmit;

@end

@interface FeedbackCenterView : UIView

@property (strong,nonatomic) id<FeedbackCenterViewDelegate> delegate;

+(instancetype) xibView;

-(void) updateView:(CGSize) size;


@end
