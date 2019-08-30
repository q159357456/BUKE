//
//  ARReportModel.h
//  MiniBuKe
//
//  Created by chenheng on 2019/6/20.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARReportModel : NSObject
@property(nonatomic,copy)NSString* groupId;
@property(nonatomic,copy)NSString* eventId;
@property(nonatomic,copy)NSString* startTime;
@property(nonatomic,copy)NSString* endTime;
@property(nonatomic,copy)NSString* detail;
@property(nonatomic,copy)NSString* clientId;
@property(nonatomic,copy)NSString* userName;
+(ARReportModel*)getModelWithEventId:(NSString*)eventId Detail:(NSString*)detail;
@end

NS_ASSUME_NONNULL_END
