//
//  BottomBuyView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BottomBuyView : UIView
@property(nonatomic,strong)UILabel *label1;
@property(nonatomic,strong)UILabel *label2;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIView *lineView;
-(void)reSizeLineWith;
@end

NS_ASSUME_NONNULL_END
