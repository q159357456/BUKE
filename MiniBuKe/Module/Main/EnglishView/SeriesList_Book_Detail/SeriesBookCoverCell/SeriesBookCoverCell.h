//
//  SeriesBookCoverCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeachingDetail.h"
#define SeriesBookCoverCell_Event @"SeriesBookCoverCell_Event"
@interface SeriesBookCoverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cover_imageview;
@property (weak, nonatomic) IBOutlet UILabel *teaching_namelabel;
@property (weak, nonatomic) IBOutlet UILabel *teaching_authorlabel;
@property (weak, nonatomic) IBOutlet UILabel *teaching_nationlable;
@property (weak, nonatomic) IBOutlet UILabel *teaching_publiclabel;
@property (weak, nonatomic) IBOutlet UIView *teaching_relationview;
@property (weak, nonatomic) IBOutlet UIView *x_view;
@property(nonatomic,strong)TeachingDetail *teaching_detail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cover_Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cover_Leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cover_With;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *x_view_Leading;


@end
