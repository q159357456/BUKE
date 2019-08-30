//
//  TagLabel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TagLabel.h"

@implementation TagLabel

-(instancetype)initWithFrame:(CGRect)frame Text:(NSString*)text{
    
    
    
    if (self = [super init]) {
       
        self.font = [UIFont systemFontOfSize:10];
        self.text = text;
        CGSize size = [self sizeThatFits:CGSizeZero];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width+12, frame.size.height);
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;
        
        
    }
    return self;
}

@end
