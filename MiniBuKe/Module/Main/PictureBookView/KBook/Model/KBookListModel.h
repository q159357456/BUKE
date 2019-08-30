//
//  KBookListModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/6/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBookListModel : NSObject

@property(nonatomic,copy)NSString *picUrl;
@property(nonatomic,copy)NSString *bookName;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,assign)NSInteger groupId;//删除K语音 标志
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,copy)NSString *kbookId;
@property(nonatomic,copy) NSString *kTime;

@property(nonatomic,copy) NSArray *kList;


+(KBookListModel *)parseDataByDictionary:(NSDictionary *)dic;

@end
