//
//  BKTiXianProgressCtr.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class tixianPgData;

NS_ASSUME_NONNULL_BEGIN

@interface BKTiXianProgressCtr : UIViewController
@property(nonatomic, copy) NSString *transactionId;
@property(nonatomic, strong) tixianPgData *data;
@end

NS_ASSUME_NONNULL_END
