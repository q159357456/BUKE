//
//  CenterBaseController.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CenterBaseController : UIViewController
@property(nonatomic,strong)UIView *topView ;
@property(nonatomic,strong)UILabel *titleLabel;
-(void)backButtonClick;
@end

NS_ASSUME_NONNULL_END
