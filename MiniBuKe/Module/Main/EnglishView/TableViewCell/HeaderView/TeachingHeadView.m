//
//  TeachingHeadView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TeachingHeadView.h"

@implementation TeachingHeadView
+(TeachingHeadView *)teaching_headerWithFrame:(CGRect)frame
{
    TeachingHeadView *view = [[NSBundle mainBundle]loadNibNamed:@"TeachingHeadView" owner:nil options:nil][0];
    view.frame = frame;
    view.backgroundColor  = COLOR_STRING(@"#f1f6fa");
    
//    [view.layer addSublayer:[view backGroundLAyer]];
    return view;
}
#pragma mark - 背景颜色渐变
-(CAGradientLayer*)backGroundLAyer{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc]init];
    gradientLayer.colors = @[(__bridge id)COLOR_STRING(@"#E9F0F6").CGColor,(__bridge id)COLOR_STRING(@"#F7F9FB").CGColor,(__bridge id)COLOR_STRING(@"#F1F1F1").CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.locations = @[@0.1f,@0.6f,@1.0f];
    return gradientLayer;
    
}
-(void)setImageview:(UIImageView *)imageview
{
    _imageview = imageview;
    _imageview.image = [UIImage imageNamed:@"mate_kidbook"];
}

@end
