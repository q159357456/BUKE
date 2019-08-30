//
//  StoryListModel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryListModel.h"

@implementation StoryListModel

+(StoryListModel *)parseByDictionary:(NSDictionary *)dictioanry
{
    StoryListModel *model = nil;
    if (dictioanry != nil) {
        model = [[StoryListModel alloc]init];
        model.name = ![[dictioanry objectForKey:@"name"] isKindOfClass:[NSNull class]] ? [dictioanry objectForKey:@"name"] : @"";
        model.picUrl = ![[dictioanry objectForKey:@"picUrl"] isKindOfClass:[NSNull class]] ? [dictioanry objectForKey:@"picUrl"] : @"";
        NSInteger sumTime = ![[dictioanry objectForKey:@"sumTime"] isKindOfClass:[NSNull class]] ? [[dictioanry objectForKey:@"sumTime"] integerValue] : 0;
        model.sumTime = [model getHHMMSSFromSS:sumTime];
        model.storyCount = ![[dictioanry objectForKey:@"storyCount"] isKindOfClass:[NSNull class]] ? [[dictioanry objectForKey:@"storyCount"] integerValue] : 0;
        model.storyId = ![[dictioanry objectForKey:@"id"] isKindOfClass:[NSNull class]] ? [[dictioanry objectForKey:@"id"] integerValue] : 0;
    }
    
    return model;
}

-(NSString *)getHHMMSSFromSS:(NSInteger )seconds
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%0.2ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%0.2ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%0.2ld",seconds%60];
    
    //format of time
    NSString *format_time;
    if ([str_hour integerValue] < 1) {
        format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    }else{
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }
    return format_time;
}

@end
