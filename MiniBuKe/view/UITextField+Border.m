//
//  UITextField+Border.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "UITextField+Border.h"

@implementation UITextField (Border)

-(void)addBottomBorder:(CGFloat)width{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexStr:@"#D3D3D3"];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
        make.height.mas_offset(width);
    }];
}

-(void)setInputSpace:(CGFloat)space{
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.leftView =self.rightView =  spaceView;
    self.leftViewMode = UITextFieldViewModeAlways;
}



@end
