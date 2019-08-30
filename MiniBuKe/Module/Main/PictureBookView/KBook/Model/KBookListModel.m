//
//  KBookListModel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookListModel.h"

@implementation KBookListModel

+(KBookListModel *)parseDataByDictionary:(NSDictionary *)dic
{
    KBookListModel *model;
    if (dic != nil) {
        model = [[KBookListModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
    }
    
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.kbookId = (NSString *)value;
    }
}

-(void)setNilValueForKey:(NSString *)key
{
    [self setValue:@"" forKey:key];
}


@end
