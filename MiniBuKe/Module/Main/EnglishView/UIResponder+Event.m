//
//  UIResponder+Event.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "UIResponder+Event.h"

@implementation UIResponder (Event)
-(void)eventName:(NSString *)eventname Params:(id)params
{
    [self.nextResponder eventName:eventname Params:params];
}
@end
