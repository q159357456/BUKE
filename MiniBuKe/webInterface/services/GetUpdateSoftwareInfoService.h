//
//  GetUpdateSoftwareInfoService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"
#import "VersionInfo.h"

@interface GetUpdateSoftwareInfoService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) VersionInfo *mVersionInfo;


-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
setUserId:(NSString *) userId
setVersionNumber:(NSString *) versionNumber;

@end
