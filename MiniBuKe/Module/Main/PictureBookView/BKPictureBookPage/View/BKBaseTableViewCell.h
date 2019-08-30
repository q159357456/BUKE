//
//  BKBaseTableViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/1.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKBaseTableViewCell : UITableViewCell

+ (instancetype)BKBaseTableViewCellWithTableView:(UITableView *)tableView;

+ (CGFloat)heightForCellWithObject:(id __nullable)obj;

@end

NS_ASSUME_NONNULL_END
