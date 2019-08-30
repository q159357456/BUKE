//
//  SeriesBookObject.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface SeriesBookObject : NSObject

@property(nonatomic,strong) NSString *sort;
@property(nonatomic,strong) NSString *bookId;
@property(nonatomic,strong) NSString *bookName;
@property(nonatomic,strong) NSString *bookPath;
@property(nonatomic,strong) NSString *bookType;
@property(nonatomic,strong) NSString *coverPic;
@property(nonatomic,strong) NSString *storyCount;
@property(nonatomic,strong) NSString *sumTime;

+(SeriesBookObject *) withObject:(NSDictionary *) dic;
//"sort": 2,
//"bookId": 10,
//"bookName": "华夫先生",
//"bookPath": "http://xiaobuke.oss-cn-beijing.aliyuncs.com/9787550277212/P0.jpg",
//"bookType": 1

@end
