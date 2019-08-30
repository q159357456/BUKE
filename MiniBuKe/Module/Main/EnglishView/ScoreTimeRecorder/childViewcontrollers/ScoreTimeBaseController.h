//
//  ScoreTimeBaseController.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreMidView.h"
#import "ScoreBottomView.h"
#import "DrawingView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ScoreTimeBaseController : UIViewController
@property(nonatomic,strong)DrawingView *drawingView;
@property(nonatomic,strong)ScoreMidView *scoreMidView;
@property(nonatomic,strong)ScoreBottomView *scoreBottomView;
@end

NS_ASSUME_NONNULL_END
