//
//  PayResultController.h
//  MiniBuKe
//
//  Created by chenheng on 2019/7/15.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayResultController : CenterBaseController
@property(nonatomic,assign)BOOL isSuccess;
@property(nonatomic,copy)NSString * SuccessTxt;
@end

NS_ASSUME_NONNULL_END
