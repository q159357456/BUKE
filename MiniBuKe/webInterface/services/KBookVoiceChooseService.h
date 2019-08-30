//
//  KBookVoiceChooseService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/6/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface KBookVoiceChooseService : HttpInterface<HttpInterfaceDelegate>

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
 setBookId:(NSString *) bookId
   setType:(NSString *) type;

@end
