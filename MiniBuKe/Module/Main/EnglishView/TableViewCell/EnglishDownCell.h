//
//  EnglishDownCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "English_Header.h"
#import "SeriesList_Classify.h"
@interface EnglishDownCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_Lead_Constraints;
@property (weak, nonatomic) IBOutlet UILabel *moreLael;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong) SeriesList_Classify *seriesList_Classify;
+(CGFloat)EnglishDownCellRowHeight:(SeriesList_Classify*)model;
@end
