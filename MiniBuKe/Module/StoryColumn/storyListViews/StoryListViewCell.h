//
//  StoryListViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryListModel.h"

@interface StoryListViewCell : UITableViewCell


-(void)setCellWithStoryListModel:(StoryListModel *)model;

@end
