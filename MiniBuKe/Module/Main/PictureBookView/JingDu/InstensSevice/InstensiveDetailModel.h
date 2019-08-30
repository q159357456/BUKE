//
//  InstensiveDetailModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InstensiveDetailModel : NSObject
@property(nonatomic,copy)NSString *bookId;
@property(nonatomic,copy)NSString *extend;
@property(nonatomic,copy)NSString *bookName;
@property(nonatomic,copy)NSString *cover;
@property(nonatomic,copy)NSString *forAge;
@property(nonatomic,copy)NSString *categoryTag;
@property(nonatomic,copy)NSString *themeTag;
@property(nonatomic,copy)NSString *recommend;
@property(nonatomic,copy)NSString *hard;
@property(nonatomic,copy)NSString *author;
@property(nonatomic,copy)NSString *painter;
@property(nonatomic,copy)NSString *others;
@property(nonatomic,copy)NSString *publisher;
@property(nonatomic,copy)NSString *isbn;
@property(nonatomic,copy)NSString *series;
@property(nonatomic,copy)NSString *guideUrl;
@property(nonatomic,copy)NSString *introductionUrl;
@property(nonatomic,copy)NSString *column;
@property(nonatomic,strong)NSArray *columnBookList;
@property(nonatomic,copy)NSString *hasGuide;
@property(nonatomic,copy)NSString *hasIntroduction;
@property(nonatomic,copy)NSString *buyUrl;
+(InstensiveDetailModel *)getIntensiveDetail:(NSDictionary *)dic;
@end

@interface IntensiveBookModel:NSObject
@property(nonatomic,copy)NSString *bookId;
@property(nonatomic,copy)NSString *bookName;
@property(nonatomic,copy)NSString *cover;
@end

NS_ASSUME_NONNULL_END
