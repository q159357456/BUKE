//
//  StoryPlayListViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryPlayListModel.h"
#import "StoryPlayListViewController.h"

@interface StoryPlayListViewCell : UITableViewCell

@property(nonatomic,strong) UIButton *playButton;
@property(nonatomic,strong) UIButton *collectButton;
@property(nonatomic,strong) UIButton *pushButton;

@property(nonatomic,copy) NSNumber *isSelected;//1:选中, 0:没有选中
//@property(nonatomic,assign) BOOL isCollected;//是否收藏

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,strong) StoryPlayListModel *playModel;

-(void)setCellWithStoryPlayListModel:(StoryPlayListModel *)model setStoryPlaySourceType:(StoryPlaySourceType) sourceType;

@end
