//
//  MyNavigationBar.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "MyNavigationBar.h"

@implementation MyNavigationBar

-(void)layoutSubviews
{
    [super layoutSubviews];
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), Height_NavBar);
        for (UIView *view in self.subviews) {
            if([NSStringFromClass([view class]) containsString:@"Background"]) {
                view.frame = self.bounds;
            }
            else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
                CGRect frame = view.frame;
                frame.origin.y = Height_StatusBar;
                frame.size.height = self.bounds.size.height - frame.origin.y;
                view.frame = frame;
            }
        }
    }
#endif
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
