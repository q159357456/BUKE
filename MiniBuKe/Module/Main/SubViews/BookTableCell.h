//
//  BookTableCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/8.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BookTableCell_kCellWidth 104
#define BookTableCell_kCellHeight 144

@class SeriesBookObject;

@interface BookTableCell : UITableViewCell

+(instancetype)xibTableViewCell;

-(void) updateData:(SeriesBookObject *)SeriesBookObject;
@end
