//
//  StoryPlayListViewController.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryListModel.h"

typedef NS_ENUM(NSUInteger,StoryPlaySourceType) {
    StoryPlaySourceType_PlayList,//从播放列表
    StoryPlaySourceType_Collect,//故事收藏
    StoryPlaySourceType_Recent,//最近播放
};

@interface StoryPlayListViewController : StoryBaseViewController

@property(nonatomic,strong)StoryListModel *listModel;

@property(nonatomic,assign) StoryPlaySourceType sourceType;

@end
