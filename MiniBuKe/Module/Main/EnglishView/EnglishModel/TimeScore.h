//
//  TimeScore.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeScore : NSObject
@property(nonatomic,copy)NSString * score;
@property(nonatomic,copy)NSString * time;
@property(nonatomic,copy)NSString * fluency;
@property(nonatomic,copy)NSString * phone;
@property(nonatomic,copy)NSString * stress;
@property(nonatomic,copy)NSString * word;
@property(nonatomic,copy)NSString *book;
@property(nonatomic,copy)NSString *timeAndScore;
@end

NS_ASSUME_NONNULL_END
