//
//  ListenerCollectCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/6/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDMCustomMusicPlayModel+Extenal.h"
@interface ListenerCollectCell : UITableViewCell

+(instancetype)xibTableViewCell;
- (void)loadData:(XYDMCustomMusicPlayModel*)model;
-(void) updateViewData:(CGSize ) size;
@end
