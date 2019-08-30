//
//  BKMoreNewBookListModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewListData,BKNewBookData;

NS_ASSUME_NONNULL_BEGIN

@interface BKMoreNewBookListModel : NSObject

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) BOOL success;
@property (copy, nonatomic) NSString *message;
@property (strong, nonatomic) NewListData *data;

@end

@interface NewListData :NSObject

@property (strong, nonatomic) NSMutableArray *booklist;

@end

@interface BKNewBookData : NSObject

@property (copy, nonatomic) NSString *coverPic;
@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *groupId;
@property (copy, nonatomic) NSString *bookId;
@property (copy, nonatomic) NSString *name;

@end

NS_ASSUME_NONNULL_END
