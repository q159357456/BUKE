//
//  StoryListModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryListModel : NSObject

@property(nonatomic,copy)NSString *picUrl;
@property(nonatomic,copy)NSString *sumTime;
@property(nonatomic,assign)NSInteger storyCount;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger storyId;


+(StoryListModel *)parseByDictionary:(NSDictionary *)dictioanry;

@end
