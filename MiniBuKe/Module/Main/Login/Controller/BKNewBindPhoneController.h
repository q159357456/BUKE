//
//  BKNewBindPhoneController.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKNewBindPhoneController : UIViewController
@property (nonatomic, copy) void(^iftryLoginAgainClick)(NSString* phonestr,NSString*phoneArea);
@property (nonatomic, copy) NSString *unionId;
@end

NS_ASSUME_NONNULL_END
