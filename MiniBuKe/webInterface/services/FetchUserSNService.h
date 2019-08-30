//
//  FetchUserSNService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpInterface.h"

@interface FetchUserSNService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,copy) NSString *mSNString;
@property (nonatomic,copy) NSString *mRobotVersion;
@property (nonatomic,copy) NSString *mBindTime;
@property (nonatomic,copy) NSString *type;

//"sn": "OJ1805W010001"

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN;

@end
