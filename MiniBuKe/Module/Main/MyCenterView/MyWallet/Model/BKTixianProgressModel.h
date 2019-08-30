//
//  BKTixianProgressModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class tixianPgData;

NS_ASSUME_NONNULL_BEGIN

@interface BKTixianProgressModel : NSObject
@property (nonatomic, assign) NSInteger code;
@property (copy, nonatomic) NSString *msg;
@property (strong, nonatomic) tixianPgData *data;
@end

@interface tixianPgData : NSObject
@property (nonatomic, assign) NSInteger applyType;//申请状态(申请状态,0.申请已经提交 1.已经提现)
@property (copy, nonatomic) NSString *createTime;//交易时间
@property (copy, nonatomic) NSString *expectTime;//预计时间
@end

NS_ASSUME_NONNULL_END
