//
//  ClassifyMenuView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CategoryType){
    CategoryBook,
    CategoryStory,
};

@class BookCategoryObject;
@class StoryCategoryObject;

@interface ClassifyMenuView : UIView

@property(nonatomic,assign) CategoryType categoryType;
@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) BookCategoryObject *mBookCategoryObject;
@property(nonatomic,strong) StoryCategoryObject *mStoryCategoryObject;

-(void) updateData:(NSString *) str setImageUrl:(NSString *) imageUrl;

-(void) show;

-(void) hide;

@end
