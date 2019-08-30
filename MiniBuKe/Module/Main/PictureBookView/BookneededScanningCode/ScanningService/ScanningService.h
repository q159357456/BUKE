//
//  ScanningService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookStatusModle.h"
NS_ASSUME_NONNULL_BEGIN

@interface ScanningService : NSObject
+(instancetype)BookRegister:(NSString*)isbn :(void(^)(BookStatusModle *model,NSError *error))completionHandler;
@end
NS_ASSUME_NONNULL_END
