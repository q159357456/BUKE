//
//  SendAudioToRobotSerive.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/24.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpPostArrayInterface.h"

@interface SendAudioToRobotSerive : HttpPostArrayInterface<HttpPostArrayInterfaceDelegate>

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
    setAudioUrlList:(NSArray *) urlList;

@end
