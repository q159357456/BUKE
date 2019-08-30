//
//  TeachingDetail.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Teaching_Catagory.h"
@interface TeachingDetail : NSObject
//@property(nonatomic,copy)NSString *ageId;
@property(nonatomic,copy)NSString *teachingName;
@property(nonatomic,copy)NSString *author;
@property(nonatomic,copy)NSString *publisher;
@property(nonatomic,copy)NSString *cover;
@property(nonatomic,strong)NSArray *otherTeachingList;
@property(nonatomic,strong)NSArray *introductionList;
@property(nonatomic,strong)NSString *introduction;
@property(nonatomic,strong)NSString *country;
+(TeachingDetail*)get_teaching_detail:(NSDictionary*)dic;
@end
