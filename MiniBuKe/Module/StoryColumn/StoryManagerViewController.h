//
//  StoryManagerViewController.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryPlayListViewController.h"

@interface StoryManagerViewController : StoryBaseViewController

@property(nonatomic,strong) NSArray *dataArray;

@property(nonatomic,assign) StoryPlaySourceType sourceType;

@end
