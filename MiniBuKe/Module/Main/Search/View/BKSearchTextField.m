//
//  BKSearchTextField.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/8.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKSearchTextField.h"
@interface BKSearchTextField()

@end

@implementation BKSearchTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10; //像右边偏移
    return iconRect;
}
//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{

    return CGRectInset(bounds, 30, 0);
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{

    return CGRectInset(bounds, 30, 0);
}

-(void)drawPlaceholderInRect:(CGRect)rect {
    CGSize placeholderSize = [self.placeholder sizeWithAttributes:
                              @{NSFontAttributeName : self.font}];
    
    [self.placeholder drawInRect:CGRectMake(0, (rect.size.height - placeholderSize.height)/2, rect.size.width, rect.size.height) withAttributes:
     @{NSForegroundColorAttributeName : COLOR_STRING(@"#999999"),
       NSFontAttributeName : self.font}];
}

@end
