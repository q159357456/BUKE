//
//  Teaching_Catagory.h
//  MiniBuKe
//
//  Created by 秦根 on 2018/9/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Teaching_Catagory : NSObject
@property(nonatomic,copy)NSString *teachingId;
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *sort;
@property(nonatomic,copy)NSString *categoryName;
//
@property(nonatomic,assign)BOOL isSelected;
@end
