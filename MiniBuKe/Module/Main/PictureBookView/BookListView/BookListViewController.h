//
//  BookListViewController.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookCategoryObject;

@interface BookListViewController : UIViewController

//自定义初始化
-(instancetype)init:(NSArray *) dataArray mBookCategoryObject:(BookCategoryObject *) mBookCategoryObject;
-(void) updateDataView;

@end
