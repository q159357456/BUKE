//
//  LoginMaskingView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/21.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "LoginMaskingView.h"

@implementation LoginMaskingView

+(instancetype)GetLoginMask{
    
    return [[LoginMaskingView alloc]init];
}
-(instancetype)init
{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imageView.image = [UIImage imageNamed:@"LoginMask"];
        [self addSubview:self.imageView];
    }
    return self;
}
@end
