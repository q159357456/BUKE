//
//  ARReportEndTimeHandle.h
//  MiniBuKe
//
//  Created by chenheng on 2019/6/21.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARReportModel.h"
@interface ARReportEndTimeHandle : NSObject
+(instancetype)singleton;
@property(nonatomic,strong)ARReportModel * lastReportModel;
-(void)updateEndTime;
-(void)restoration;
@end


