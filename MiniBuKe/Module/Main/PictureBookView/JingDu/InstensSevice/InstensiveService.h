//
//  InstensiveService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstensiveDetailModel.h"
#import "HttpInterface.h"
NS_ASSUME_NONNULL_BEGIN

@interface InstensiveService : HttpInterface<HttpInterfaceDelegate>
@property(nonatomic,strong)InstensiveDetailModel *instensiveDetailModel;
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN Bookid:(NSString*)bookid;
@end

NS_ASSUME_NONNULL_END
