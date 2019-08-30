//
//  BkSearchResultModel.h
//  MiniBuKe
//
//  Created by chenheng on 2019/1/11.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BkSearchResultModel : NSObject

@property (copy, nonatomic) NSString *aintro;
@property (copy, nonatomic) NSString *coverPic;
@property (copy, nonatomic) NSString *resultId;
@property (copy, nonatomic) NSString *storyNumber;
@property (copy, nonatomic) NSString *storyTime;
@property (copy, nonatomic) NSString *title;

@end

NS_ASSUME_NONNULL_END
