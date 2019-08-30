//
//  LeftMenuView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@protocol HomeMenuViewDelegate <NSObject>

-(void)LeftMenuViewClick:(NSInteger)tag;

@end

@interface LeftMenuView : UIView<HomeDelegate>

@property (nonatomic ,weak)id <HomeMenuViewDelegate> customDelegate;

@property(nonatomic,copy) NSString *nickName;
@property(nonatomic,copy) NSString *appellativeName;
@property(nonatomic,copy) NSString *imageUlr;

@end
