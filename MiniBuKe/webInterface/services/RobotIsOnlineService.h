//
//  RobotIsOnlineService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface RobotIsOnlineService : HttpInterface<HttpInterfaceDelegate>

@property(nonatomic,assign) BOOL isOnline;

-(id) initWithDeviceId:(NSString *)deviceId setToken:(NSString *)token setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock;

@end
