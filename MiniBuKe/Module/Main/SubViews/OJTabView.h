//
//  OJTabView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/8/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
// 

#import <UIKit/UIKit.h>
typedef void (^onStartTabClick)(void);
typedef void (^onTabClick)(void);

@interface OJTabView : UIView

@property (nonatomic) BOOL isSelect;

@property void (^onStartTabClick)(void);
@property void (^onTabClick)(void);

-(instancetype)initWithFrame:(CGRect)frame setTitle:(NSString *) title setDefaultIcon:(NSString *) imageName setPressIcon:(NSString *) imageName setOnTabClick:(onTabClick) onTabClickBlock;
-(instancetype)initWithFrame:(CGRect)frame setTitle:(NSString *) title setDefaultIcon:(NSString *) imageName setPressIcon:(NSString *) imageName
               setOnStartTabClick:(onStartTabClick) onStartTabClick setOnTabClick:(onTabClick) onTabClickBlock;

-(void) setTabClickStatus:(BOOL) isClick;
@end
