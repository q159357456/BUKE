//
//  BKHomeBookCategoryModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CategoryData,bookCategoryDataModel;

@interface BKHomeBookCategoryModel : NSObject

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) BOOL success;
@property (copy, nonatomic) NSString *message;
@property (strong, nonatomic) CategoryData *data;

@end

@interface CategoryData : NSObject

@property (strong, nonatomic) NSMutableArray *bookCategoryList;

@end

@interface bookCategoryDataModel : NSObject

@property (copy, nonatomic) NSString *categoryName;
@property (copy, nonatomic) NSString *picUrl;
@property (copy, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSArray *categoryLists;

@end

NS_ASSUME_NONNULL_END
