//
//  DataBaseTool.h
//  MiniBuKe
//
//  Created by chenheng on 2018/7/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkMessageModel.h"


@interface DataBaseTool : NSObject

+(DataBaseTool *)shareDataBaseTool;



+(void)openTalkDB;

+(void)addMessageModel:(TalkMessageModel *)model;

+(void)updateMessageModel:(TalkMessageModel *)model;

+(void)addMessageModelWithArray:(NSArray *)array;

+(NSArray *)selectModelData;

@end
