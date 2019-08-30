//
//  IntensTableHeadView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstensiveDetailModel.h"
#define IntensTableHeadView_Event @"IntensTableHeadView_Event"
NS_ASSUME_NONNULL_BEGIN

@interface IntensTableHeadView : UIView
@property(nonatomic,strong)UIImageView* imageView;
@property(nonatomic,strong)UILabel *lable;
@property(nonatomic,strong)UIImageView *backGImageView;
@property(nonatomic,strong)InstensiveDetailModel *instensiveDetailModel;
@end

NS_ASSUME_NONNULL_END
