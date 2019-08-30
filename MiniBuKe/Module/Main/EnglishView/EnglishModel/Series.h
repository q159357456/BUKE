//
//  Series.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Series : NSObject
@property(nonatomic,copy)NSString *bookId;
@property(nonatomic,copy)NSString *bookName;
@property(nonatomic,copy)NSString *bookPath;
@property(nonatomic,copy)NSString *bookType;
@property(nonatomic,copy)NSString *seriesName;
@property(nonatomic,copy)NSString *sort;
@property(nonatomic,copy)NSString *storyCount;
@property(nonatomic,copy)NSString *sumTime;
//自定义属性
@end
