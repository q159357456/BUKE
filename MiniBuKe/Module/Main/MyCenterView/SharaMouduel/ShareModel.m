//
//  ShareModel.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/24.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "ShareModel.h"
#import "NSObject+YYModel.h"
@implementation ShareModel
+(ShareModel *)getShareModelWithDic:(NSDictionary *)dic
{
    ShareModel *model = [ShareModel yy_modelWithDictionary:dic];
    return model;
}
@end

@implementation ShareURLModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"mdescription":@"description"};
}

@end

@implementation ShareMinProjModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"mdescription":@"description"};
}


@end


@implementation ShareImageModel



@end

