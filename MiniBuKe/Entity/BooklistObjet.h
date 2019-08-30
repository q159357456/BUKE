//
//  BooklistObjet.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BooklistObjet : NSObject

//"coverPic": "http://xiaobuke.oss-cn-beijing.aliyuncs.com/9787554500200/P0.jpg",
//"author": "[日]渡边茂南",
//"id": 15,
//"name": "和爸爸一起玩"

@property(nonatomic,copy) NSString *coverPic;
@property(nonatomic,copy) NSString *author;
@property(nonatomic,copy) NSString *mid;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *groupId;
@property(nonatomic) BOOL isSelect;


+(BooklistObjet *) withObject:(NSDictionary *) dic;

@end
