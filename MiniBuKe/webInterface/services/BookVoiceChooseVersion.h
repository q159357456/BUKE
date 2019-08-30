//
//  BookVoiceChooseVersion.h
//  MiniBuKe
//
//  Created by chenheng on 2018/6/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"
#import "VersionListObject.h"

@interface BookVoiceChooseVersion : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) NSMutableArray *mVersionListObjects;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
setBookId:(NSString *) bookId;

@end
