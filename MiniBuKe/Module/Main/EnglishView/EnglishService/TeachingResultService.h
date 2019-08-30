//
//  TeachingResultService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpInterface.h"
#import "TimeScore.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeachingResultService : HttpInterface<HttpInterfaceDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN Type:(NSInteger)type Time:(NSInteger)time;
@end

NS_ASSUME_NONNULL_END
