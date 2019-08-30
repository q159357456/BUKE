//
//  UpBabyInfo.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/31.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^OnSuccess) (id,NSString *);//
typedef void (^OnError) (NSInteger,NSString*);
@interface UpBabyInfo : NSObject
-(void)upLoad:(NSDictionary*)dic Success:(OnSuccess)success Fail:(OnError)fail;
@end

NS_ASSUME_NONNULL_END
