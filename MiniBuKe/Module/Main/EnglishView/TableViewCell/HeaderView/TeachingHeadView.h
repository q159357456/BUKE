//
//  TeachingHeadView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeachingHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
+(TeachingHeadView *)teaching_headerWithFrame:(CGRect)frame;
@end
