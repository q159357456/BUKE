//
//  IntentBottomView.h
//  MiniBuKe
//
//  Created by chenheng on 2019/1/22.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IntentBottomView_Event @"IntentBottomView_Event"
NS_ASSUME_NONNULL_BEGIN

@interface IntentBottomView : UIView
@property(nonatomic,strong)UIButton *buyBtn;
+(instancetype)IntenBuyBottomView;
@end

NS_ASSUME_NONNULL_END
