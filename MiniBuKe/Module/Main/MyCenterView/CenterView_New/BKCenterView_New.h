//
//  BKCenterView_New.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKCenterHeaderView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BKCenterView_New : UIView
@property(nonatomic, strong)NSMutableArray *messageArray;
@property(nonatomic,strong)BKCenterHeaderView *centerHeaderView;
-(void)reload;
@end

NS_ASSUME_NONNULL_END
