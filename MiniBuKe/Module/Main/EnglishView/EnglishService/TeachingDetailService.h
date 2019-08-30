//
//  TeachingDetailService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpInterface.h"
#import "TeachingDetail.h"
@interface TeachingDetailService : HttpInterface<HttpInterfaceDelegate>
@property(nonatomic,strong)TeachingDetail *teaching_detail;
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN TeachingId:(NSString*)teachingId;
@end
