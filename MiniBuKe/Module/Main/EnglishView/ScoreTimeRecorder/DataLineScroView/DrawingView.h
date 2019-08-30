//
//  DrawingView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataLineScroView.h"
#import "TimeScore.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, DateStyleEnum) {
    Day_Style = 1,
    WeekStyle = 2,
    Month_Style =3,
    TotalStyle = 4
};
typedef NS_ENUM(NSUInteger, ScoreTimeEnum) {
    Score_Style =1,
    Time_Style =2,
};
@class DrawingView;
@protocol ScroChosenDelegate <NSObject>
@optional
-(void)scroStop:(TimeScore*)timeScore;
@end
@interface DrawingView : UIView
@property(nonatomic,assign)DateStyleEnum dateStyleEnum;
@property(nonatomic,assign)ScoreTimeEnum scoreTimeEnum;
@property(nonatomic,weak)id<ScroChosenDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
