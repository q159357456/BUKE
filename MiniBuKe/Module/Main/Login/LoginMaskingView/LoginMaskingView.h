//
//  LoginMaskingView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/21.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginMaskingView : UIView
@property(nonatomic,strong)UIImageView *imageView;
+(instancetype)GetLoginMask;
@end

NS_ASSUME_NONNULL_END
