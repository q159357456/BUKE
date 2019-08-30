//
//  BKUserSNFetchModel.h
//  MiniBuKe
//
//  Created by chenheng on 2019/5/6.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SNDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface BKUserSNFetchModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (copy, nonatomic) NSString *message;
@property (nonatomic, strong) SNDataModel *data;

@end

@interface SNDataModel : NSObject
//type : 1 Q1 ,2 Titan ,4 babyCare,5 chill
@property (nonatomic, copy) NSString *sn;
@property (nonatomic, copy) NSString *wifiImg;
@property (nonatomic, copy) NSString *unWifiImg;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *bindTime;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *uid;

@end

NS_ASSUME_NONNULL_END
