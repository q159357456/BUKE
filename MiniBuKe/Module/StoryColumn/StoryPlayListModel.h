//
//  StoryPlayListModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDM_OJ_CustomeModel.h"
@interface StoryPlayListModel : XYDM_OJ_CustomeModel<NSCoding>

//@property(nonatomic,assign)NSInteger playId;
//@property(nonatomic,copy)NSString *url;
//@property(nonatomic,copy)NSString *picUrl;
//@property(nonatomic,copy)NSString *storyName;
//@property(nonatomic,copy)NSString *longTime;
//@property(nonatomic,assign)BOOL isCollect; // 0表示已收藏  1表示未收藏

@property(nonatomic,assign)BOOL isSelect;//管理页面 进行对模型选择

@property(nonatomic,assign)BOOL isPush;

@property(nonatomic,assign)NSInteger oj_id;
@property(nonatomic,copy)NSString * transformTime;//新加的

+(StoryPlayListModel *)parseByDictionary:(NSDictionary *)dic;
+(void)getObjectList:(NSArray*)jsonList CallBack:(void(^)(NSArray * array))block;
@end
