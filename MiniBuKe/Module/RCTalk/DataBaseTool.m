//
//  DataBaseTool.m
//  MiniBuKe
//
//  Created by chenheng on 2018/7/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "DataBaseTool.h"
#import <FMDB.h>
#import "BKUtils.h"

@interface  DataBaseTool()

@property(nonatomic,strong) FMDatabaseQueue *queue;

@end


@implementation DataBaseTool

+(DataBaseTool *)shareDataBaseTool
{
    static DataBaseTool *tool;
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        tool = [[DataBaseTool alloc] init];
//        [self openTalkDB];
        //沙盒路径
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataPath = [path stringByAppendingPathComponent:@"talk.sqlite"];
        
        //使用数据库队列
        tool.queue = [FMDatabaseQueue databaseQueueWithPath:dataPath];
        
        //打开数据库
        [tool.queue inDatabase:^(FMDatabase * _Nonnull db) {
            BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS s_talkMessages(id integer primary key autoincrement,userId text,model blob);"];
            
            if (result) {
                NSLog(@"创表成功");
            }else{
                NSLog(@"创表失败");
            }
        }];
    });
    
    return tool;
}


+(void)openTalkDB
{
    DataBaseTool *tool = [DataBaseTool shareDataBaseTool];
    
    //沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [path stringByAppendingPathComponent:@"talk.sqlite"];
    
    //使用数据库队列
    tool.queue = [FMDatabaseQueue databaseQueueWithPath:dataPath];
    
    //打开数据库
    [tool.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS s_talkMessages(id integer primary key autoincrement,userId text,model blob);"];
        
        if (result) {
            NSLog(@"创表成功");
        }else{
            NSLog(@"创表失败");
        }
    }];
}

+(void)addMessageModel:(TalkMessageModel *)model
{
    DataBaseTool *tool = [DataBaseTool shareDataBaseTool];
    [tool.queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *userId = APP_DELEGATE.mLoginResult.userId;
        
        //把模型通过归档转换成二进制数据
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        //把数据插入数据库
        [db executeUpdate:@"insert into s_talkMessages(userId,model) values(?,?);",userId,data];
        
    }];
}

//-(NSDictionary *) getHistoryAccountLogin
//{
//    NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"im_mid"];
//    //    if (dic != nil) {
//    //        self.mLoginResult = [[LoginResult alloc] init];
//    //        self.mLoginResult.imageUlr = [dic objectForKey:@"imageUlr" ];
//    //    }
//    return dic;
//}


+(void)updateMessageModel:(TalkMessageModel *)model
{
    NSLog(@"updateMessageModel ===> %@",model);
    if (model.mId == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",(int)model.messageReadStatus ] forKey:[NSString stringWithFormat:@"%@", model.voiceUrl]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",(int)model.messageReadStatus ] forKey:[NSString stringWithFormat:@"%d",model.mId ]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

+(void)addMessageModelWithArray:(NSArray *)array
{
    for (TalkMessageModel *model in array) {
        [self addMessageModel:model];
    }
}


+(NSArray *)selectModelData
{
    __block NSMutableArray *mutableArray = [NSMutableArray array];
    DataBaseTool *tool = [DataBaseTool shareDataBaseTool];
    [tool.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *set = nil;
        set = [db executeQuery:@"select *from s_talkMessages where userId = ?;",APP_DELEGATE.mLoginResult.userId];
        
        while (set.next) {
            NSData *mid = [set dataForColumn:@"id"];
            
//            NSLog(@"set.next ===> %d",[BKUtils dataToInt:mid]);
            //取出模型数据
            NSData *data = [set dataForColumn:@"model"];
            //反归档
            TalkMessageModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            model.mId = [BKUtils dataToInt:mid];
            id obj = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",model.mId ]];
            if (obj != nil) {
                model.messageReadStatus = MessageReadStatusRead;
            } else {
                obj = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",model.voiceUrl ]];
                if (obj != nil) {
                    model.messageReadStatus = MessageReadStatusRead;
                } 
            }
            
            [mutableArray addObject:model];
        }
    }];
    
    return [NSArray arrayWithArray:mutableArray];
}

@end
