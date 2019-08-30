//
//  BKBabyCareMainCtr.h
//  MiniBuKe
//
//  Created by Don on 2019/4/28.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//
//babycare主页面Controller 
#import <UIKit/UIKit.h>
@class XG_NoticeModel;

NS_ASSUME_NONNULL_BEGIN

@interface BKBabyCareMainCtr : UIViewController
@property (nonatomic, assign) BOOL isNeedPopMore;
@property (nonatomic, strong) XG_NoticeModel *noticModel;
@end

NS_ASSUME_NONNULL_END
