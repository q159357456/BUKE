//
//  BKCenterHeaderView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyRobotInfo.h"
#import "AddBabyInfoView.h"
#import "BKUserInfoView.h"
#import "BKCenterBtnListCell.h"
#define BKCenterHeaderView_Event @"BKCenterHeaderView_Event"
static NSString *BKCenterHeaderView_BabyInfo = @"BKCenterHeaderView_BabyInfo";
NS_ASSUME_NONNULL_BEGIN

@interface BKCenterHeaderView : UIView
@property(nonatomic,strong)BKUserInfoView *userInfoView;
@property(nonatomic,strong)AddBabyInfoView *addBabyInfoView;
@property(nonatomic,strong)BabyRobotInfo * babyRobotInfo;
@property(nonatomic,strong)BKCenterBtnListCell * btnlistView;
@property(nonatomic,strong)UIImageView * memberImageView;
@property(nonatomic,strong)UIButton * newsButton;
@property(nonatomic,strong)MemberInfo * memberInfo;
@end

NS_ASSUME_NONNULL_END
