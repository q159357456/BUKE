//
//  NavView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKPhotoImage.h"


@interface NavView : UIView

@property (nonatomic, copy) void(^navViewBack)();
@property (nonatomic, copy) void(^quitDoneBack)();

// 创建nav
-(void)createNavViewTitle:(NSString *)title;

-(void)changeBtnWithNumber:(NSInteger)number;

@end
