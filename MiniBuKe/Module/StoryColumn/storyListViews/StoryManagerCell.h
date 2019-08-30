//
//  StoryManagerCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryPlayListModel.h"
#import "StoryPlayListViewController.h"

@interface StoryManagerCell : UITableViewCell

@property(nonatomic,assign) BOOL isAllSelected;
@property(nonatomic,copy) NSString *titleName;
@property(nonatomic,copy) NSString *timeString;

@property(nonatomic,strong) UIButton *selectButton;
@property(nonatomic,strong) UIButton *playButton;


-(void)setDisplayValueByData:(StoryPlayListModel *)model setStoryPlaySourceType:(StoryPlaySourceType) sourceType;

@end
