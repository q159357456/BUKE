//
//  ServerVersionInfoService.h
//  IOSAirPurifierProject
//
//  Created by Stone on 13-10-31.
//  Copyright (c) 2013年 IOSAirPurifierProject. All rights reserved.
//

#import "HttpInterface.h"
//#import "SystemVersionInfo.h"

@interface ServerVersionInfoService : HttpInterface

//@property (nonatomic,strong) SystemVersionInfo *versionInfo;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock;

@end
