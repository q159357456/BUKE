//
//  PutFeedBackService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/21.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpInterface.h"

@interface PutFeedBackService : HttpInterface<HttpInterfaceDelegate>

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
setInfoContent:(NSString *) infoContent
setInfoType:(NSString *) infoType;

@end
