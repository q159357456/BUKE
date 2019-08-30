//
//  EnglishSettingManager.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, BACK_TO_PAGE) {
    BACK_TO_FIST_PAGE,
    BACK_TO_SECOND_PAGE
  
};
@interface EnglishSettingManager : NSObject
@property(nonatomic,assign)BACK_TO_PAGE backToWhatPage;
@property(nonatomic,assign)BOOL AGE_TO_ALL;
+(instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
