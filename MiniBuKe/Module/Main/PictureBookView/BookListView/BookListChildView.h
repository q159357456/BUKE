//
//  BookListChildView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookCategoryObject;

@interface BookListChildView : UIView

-(instancetype)initWithFrame:(CGRect)frame setBookCategoryObject:(BookCategoryObject *) mBookCategoryObject;

@end
