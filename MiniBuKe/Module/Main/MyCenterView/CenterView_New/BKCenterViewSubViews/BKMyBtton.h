//
//  BKMyBtton.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKMyBtton : UIButton
@property(nonatomic,strong)UIImageView *titleImage;
@property(nonatomic,strong)UILabel *contentText;
-(instancetype)initWithFrame:(CGRect)frame ImageFrame:(CGRect)imageFrame TitleFrame:(CGRect)titleFrame;
@end

NS_ASSUME_NONNULL_END
