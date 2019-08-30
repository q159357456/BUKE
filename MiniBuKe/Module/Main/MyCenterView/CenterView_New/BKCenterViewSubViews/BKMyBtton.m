//
//  BKMyBtton.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKMyBtton.h"

@implementation BKMyBtton

-(instancetype)initWithFrame:(CGRect)frame ImageFrame:(CGRect)imageFrame TitleFrame:(CGRect)titleFrame {
    
    self = [super initWithFrame:frame];
    if (self) {

        self.titleImage = [[UIImageView alloc]initWithFrame:imageFrame];
        self.contentText = [[UILabel alloc]initWithFrame:titleFrame];
        self.contentText.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleImage];
        [self addSubview:self.contentText];
    }
    return self;
}

@end
