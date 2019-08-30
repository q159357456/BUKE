//
//  BKSNCallRecordsModel.h
//  MiniBuKe
//
//  Created by chenheng on 2019/5/8.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class CallRecordData;

@interface BKSNCallRecordsModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (copy, nonatomic) NSString *msg;
@property (nonatomic, strong) CallRecordData *data;

@end

@interface CallRecordData : NSObject

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) BOOL isLastPage;

@end

@interface recordModel : NSObject

@property (copy, nonatomic) NSString *recordId;
@property (copy, nonatomic) NSString *relationship;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *sn;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *longTime;
@property (copy, nonatomic) NSString *state;//0 未接通 1 已接听 2已挂断
@property (copy, nonatomic) NSString *whoStart; // 0 机器主叫  1 机器接听

@end

NS_ASSUME_NONNULL_END
