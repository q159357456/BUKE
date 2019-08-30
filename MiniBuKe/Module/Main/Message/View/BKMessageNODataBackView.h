//
//  BKMessageNODataBackView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKMessageNODataBackView : UIView

-(instancetype)initWithImageBound:(CGRect)imageBound WithImage:(UIImage *)image WithTitle:(NSString *)title andPicOffset:(CGFloat)picOffset andLableOffset:(CGFloat)lableOffset;
@property(nonatomic,strong) UIFont *titlefont;
@property(nonatomic,strong) UIColor *titlefontColor;

@end

NS_ASSUME_NONNULL_END
