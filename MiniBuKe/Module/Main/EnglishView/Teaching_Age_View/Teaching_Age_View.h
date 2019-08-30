//
//  Teaching_Age_View.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeachingAgeService.h"
#define TeachingAgeView_Event @"TeachingAgeView_Event"
@interface Teaching_Age_View : UIView
@property(nonatomic,strong)NSString *teachingid;
-(void)show;
-(void)disappear;
@end
