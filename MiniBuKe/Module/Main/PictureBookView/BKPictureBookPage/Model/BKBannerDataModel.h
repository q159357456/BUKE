//
//  BKBannerDataModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BannerData,BannerDataDetail;

NS_ASSUME_NONNULL_BEGIN

@interface BKBannerDataModel : NSObject

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) BOOL success;
@property (copy, nonatomic) NSString *message;
@property (strong, nonatomic) BannerData *data;

@end

@interface BannerData :NSObject

@property (strong, nonatomic) NSMutableArray *BannerList;

@end

@interface BannerDataDetail :NSObject

@property (nonatomic, assign) NSInteger bannerId;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger sortNum;
@property (copy, nonatomic) NSString *picURL;
@property (copy, nonatomic) NSString *version;
@property (copy, nonatomic) NSString *bookId;

@end

NS_ASSUME_NONNULL_END
