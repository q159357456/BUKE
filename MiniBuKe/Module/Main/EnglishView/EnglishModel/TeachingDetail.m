//
//  TeachingDetail.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TeachingDetail.h"
#import "English_Header.h"
@implementation TeachingDetail
+(TeachingDetail *)get_teaching_detail:(NSDictionary *)dic
{
    TeachingDetail *obj = (TeachingDetail*)[TeachingDetail AnalyticDic_Obj:dic];
    obj.otherTeachingList = [Teaching_Catagory AnalyticDic_Aarry:obj.otherTeachingList];
    return obj;
}
@end
