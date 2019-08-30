//
//  ScoreMidView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreMidView : UIView
@property(nonatomic,strong)UILabel *timeLable;
@property(nonatomic,strong)UILabel *wordRepeatLable;
@property(nonatomic,strong)UILabel *voiceLable;
@property(nonatomic,strong)UILabel *fluencyLable;

@end

NS_ASSUME_NONNULL_END