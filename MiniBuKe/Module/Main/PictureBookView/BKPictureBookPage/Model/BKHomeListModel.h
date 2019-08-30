//
//  BKHomeListModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HomeListData,themeDataModel,themeData,seriesBookDataModel,recommendData,recommendBookModel,LineLessonsData;

NS_ASSUME_NONNULL_BEGIN

@interface BKHomeListModel : NSObject

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) BOOL success;
@property (copy, nonatomic) NSString *message;
@property (strong, nonatomic) HomeListData *data;

@end

@interface HomeListData : NSObject

@property (strong, nonatomic) themeData *themeList;
@property (strong, nonatomic) NSMutableArray *seriesBookList;
@property (strong, nonatomic) recommendData *recommendRanks;
@property (strong, nonatomic) LineLessonsData *onlineCourse;
@end

@interface themeData : NSObject

@property (copy, nonatomic) NSString *theme;
@property (strong, nonatomic) NSMutableArray *xbkThemeList;

@end

@interface themeDataModel : NSObject

@property (copy, nonatomic) NSString *bookId;
@property (copy, nonatomic) NSString *theme;
@property (copy, nonatomic) NSString *bookName;
@property (copy, nonatomic) NSString *themeTitle;
@property (copy, nonatomic) NSString *cover;
@property (copy, nonatomic) NSString *forAge;
@property (copy, nonatomic) NSString *categoryTag;
@property (copy, nonatomic) NSString *themeTag;
@property (nonatomic, assign) NSInteger updateTime;

@end


@interface seriesBookDataModel : NSObject

@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) NSInteger seriesType;//1 为你推荐 2最新上架 3阅读排行
@property (copy, nonatomic) NSString *seriesName;
@property (copy, nonatomic) NSString *ageId;
@property (strong, nonatomic) NSMutableArray *bookList;

@end

@interface homeSeriesBookModel : NSObject

@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString *bookId;
@property (copy, nonatomic) NSString *bookName;
@property (copy, nonatomic) NSString *bookPath;
@property (nonatomic, assign) NSInteger bookType;
@property (copy, nonatomic) NSString *seriesName;
@property (nonatomic, assign) NSInteger sumTime;
@property (nonatomic, assign) NSInteger storyCount;
@property (copy, nonatomic) NSString *ageId;

@end

@interface recommendData : NSObject

@property (copy, nonatomic) NSString *seriesName;
@property (strong, nonatomic) NSMutableArray *recommendBookList;

@end

@interface recommendBookModel : NSObject

@property (copy, nonatomic) NSString *categoryId;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *recommendId;
@property (copy, nonatomic) NSString *isDelete;
@property (copy, nonatomic) NSString *recommendCover;
@property (copy, nonatomic) NSString *recommendName;
@property (copy, nonatomic) NSString *recommendPic;
@property (copy, nonatomic) NSString *recommendText;
@property (copy, nonatomic) NSString *saying;
@property (copy, nonatomic) NSString *sayingAuthor;
@property (copy, nonatomic) NSString *updateTime;

@end

@interface LineLessonsData : NSObject
@property (copy, nonatomic) NSString *seriesName;
@property (copy, nonatomic) NSArray *onlineCourseList;
@end

@interface LineLessonsModel : NSObject
@property (copy, nonatomic) NSString *courseName;
@property (copy, nonatomic) NSString *tags;
@property (copy, nonatomic) NSString *startAge;
@property (copy, nonatomic) NSString *endAge;
@property (copy, nonatomic) NSString *courseType;
@property (copy, nonatomic) NSString *courseNum;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *discountPrice;
@property (copy, nonatomic) NSString *priceType;
@property (copy, nonatomic) NSString *smallPic;
@property (copy, nonatomic) NSString *courseAddress;
@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *online;
@property (copy, nonatomic) NSString *lessonId;
@end
NS_ASSUME_NONNULL_END
