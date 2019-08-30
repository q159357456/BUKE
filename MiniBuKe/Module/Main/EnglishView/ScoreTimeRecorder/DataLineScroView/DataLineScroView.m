//
//  DataLineScroView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/15.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "DataLineScroView.h"
#import "English_Header.h"
@interface DataLineScroView()<UIScrollViewDelegate>
@property(nonatomic,assign)CGFloat contentX;
@end
@implementation DataLineScroView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.bounces = NO;
    }
    return self;
}


@end
