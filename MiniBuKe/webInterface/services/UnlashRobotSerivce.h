//
//  UnlashRobotSerivce.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpInterface.h"

@interface UnlashRobotSerivce : HttpInterface<HttpInterfaceDelegate>
//OJ1803W000021
//23420cb3b5752f65

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN;

@end
