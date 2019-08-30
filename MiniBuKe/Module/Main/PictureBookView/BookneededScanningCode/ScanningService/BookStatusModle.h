//
//  BookStatusModle.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/15.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookStatusModle : NSObject
@property(nonatomic , assign)NSInteger bookId;
@property(nonatomic , assign)NSInteger status;
@property(nonatomic , strong)NSString *url;
@end

NS_ASSUME_NONNULL_END
