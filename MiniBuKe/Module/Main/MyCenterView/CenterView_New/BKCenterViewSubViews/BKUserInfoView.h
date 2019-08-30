//
//  BKUserInfoView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKUserInfoView : UIView
@property(nonatomic,strong)UIImageView *userHeaderImageView;
@property(nonatomic,strong)UILabel *userNameLabel;
@property(nonatomic,strong)UILabel *userRelationLabel;
@property(nonatomic,strong)UIImageView * memberImageView;
@property(nonatomic,strong)UILabel * memberLabel;
-(void)reloadData;
@end

NS_ASSUME_NONNULL_END
