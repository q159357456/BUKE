//
//  BaseEntity.h
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/2/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseEntity : NSObject

//{
//    "data": {},
//    "message": "string",
//    "state": 0,
//    "success": true
//}

@property(nonatomic,assign) NSInteger state;
@property(nonatomic,assign) Boolean success;
@property(nonatomic,strong) NSString *message;

@end
