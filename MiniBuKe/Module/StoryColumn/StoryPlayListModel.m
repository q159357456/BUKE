//
//  StoryPlayListModel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryPlayListModel.h"
#import "NSObject+YYModel.h"
#import "XYDMSetting.h"
@implementation StoryPlayListModel

+(StoryPlayListModel *)parseByDictionary:(NSDictionary *)dic
{
//    NSLog(@"dic===>%@",dic);
    StoryPlayListModel *listModel = nil;
    if (dic != nil) {
        
        listModel = [[StoryPlayListModel alloc]init];
        listModel.musicId = ![[dic objectForKey:@"musicId"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"musicId"] integerValue] : -1;//id 为空设置为-1
        listModel.musicName = ![[dic objectForKey:@"musicName"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"musicName"] : @"";
        listModel.musicUrl = ![[dic objectForKey:@"musicUrl"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"musicUrl"] : @"";
//        listModel.url = [listModel.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        listModel.albumImgUrl = ![[dic objectForKey:@"albumImgUrl"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"albumImgUrl"] : @"";
//        listModel.picUrl = [listModel.picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSInteger time = ![[dic objectForKey:@"duration"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"duration"] integerValue] : 0;
        listModel.transformTime = [listModel getMMSSFromSS:time];
        
        NSInteger collectStatus = ![[dic objectForKey:@"isCollected"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"isCollected"] integerValue] : 1;//默认没有收藏
        
        listModel.isCollected = collectStatus == 0 ? YES : NO;
        
    }
    
    return listModel;
}

-(NSString *)getMMSSFromSS:(NSInteger )seconds
{
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%0.2ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%0.2ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.musicId = [[aDecoder decodeObjectForKey:@"musicId"] integerValue];
        self.musicName = [aDecoder decodeObjectForKey:@"musicName"];
        self.musicUrl = [aDecoder decodeObjectForKey:@"musicUrl"];
        self.albumImgUrl = [aDecoder decodeObjectForKey:@"albumImgUrl"];
        self.transformTime = [aDecoder decodeObjectForKey:@"transformTime"];
        self.isCollected = [[aDecoder decodeObjectForKey:@"isCollected"] boolValue];
        self.isSelect = [[aDecoder decodeObjectForKey:@"isSelect"] boolValue];
        self.isPush = [[aDecoder decodeObjectForKey:@"isPush"] boolValue];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.musicId] forKey:@"musicId"];
    [aCoder encodeObject:self.musicName forKey:@"musicName"];
    [aCoder encodeObject:self.musicUrl forKey:@"musicUrl"];
    [aCoder encodeObject:self.albumImgUrl forKey:@"albumImgUrl"];
    [aCoder encodeObject:self.transformTime forKey:@"transformTime"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isCollected] forKey:@"isCollected"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isSelect] forKey:@"isSelect"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isPush] forKey:@"isPush"];
    
}


+(void)getObjectList:(NSArray*)jsonList CallBack:(void(^)(NSArray * array))block{
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *ids = [NSMutableArray array];
    NSMutableArray *indexList = [NSMutableArray array];
    NSInteger t = 0;
    for (NSDictionary *dic in jsonList) {
        StoryPlayListModel *model = [StoryPlayListModel yy_modelWithDictionary:dic];
        [temp addObject:model];
        if (!model.musicUrl.length && model.musicId) {
            [ids addObject:[NSString stringWithFormat:@"%ld",model.musicId]];
            [indexList addObject:@(t)];
        }
        t++;
    }
    
    
    NSString *trackIds = [ids componentsJoinedByString:@","];
    NSLog(@"trackIds===>%@",trackIds);
    [XYDMSDK obtainTrackURLWithTrackIds:trackIds deviceId:nil osType:XYDMSDKOSTypeiOS snCode:XYDMTestSnCode isPaid:NO response:^(BOOL isSuccess, NSString *errMsg, NSArray<XYDMPushTrackURLModel *> *audioModels) {
        NSLog(@"audioModels===>%@",audioModels);
        for (NSInteger i=0; i<audioModels.count; i++) {
            XYDMPushTrackURLModel * tempmodel = audioModels[i];
            NSLog(@"tempmodel===>%@",tempmodel.play_url_64);
            NSInteger index = [indexList[i] integerValue];
            StoryPlayListModel *custom = temp[index];
            custom.musicUrl = tempmodel.play_url_64;
        }
        
        block(temp);
        
    }];
    
}
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"oj_id" : @"id",
             };
}
@end
