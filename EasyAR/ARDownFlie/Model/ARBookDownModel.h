//
//  ARBookDownModel.h
//  MiniBuKe
//
//  Created by chenheng on 2019/5/28.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class downModel;

@interface ARBookDownModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (copy, nonatomic) NSString *msg;
@property (nonatomic, strong) downModel *data;

@end

@interface downModel : NSObject

@property (copy, nonatomic) NSString *bookId;
@property (copy, nonatomic) NSString *dstMd5;
@property (copy, nonatomic) NSString *dstUrl;
@property (copy, nonatomic) NSString *isbn;
@property (assign, nonatomic) NSInteger pageNum;
@property (assign, nonatomic) NSInteger dstUpdateTime;
@end

NS_ASSUME_NONNULL_END
