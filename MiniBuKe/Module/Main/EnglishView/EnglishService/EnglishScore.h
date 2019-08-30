//
//  EnglishScore.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/10.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpInterface.h"
#import "Score.h"
@interface EnglishScore : HttpInterface<HttpInterfaceDelegate>
@property(nonatomic,strong)Score *score;
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN;
@end
