//
//  BKInputView.h
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+Border.h"
@interface BKInputView : UIView
@property(nonatomic,strong) UIImage *icon;
@property(nonatomic,strong) UITextField *inputText;
@property(nonatomic,strong) UIView *rightView;
@property(nonatomic,assign) CGFloat borderW;
-(void)setImageFrame:(CGRect)rect;

-(void)setIconFrame:(CGRect)rect;

@end
