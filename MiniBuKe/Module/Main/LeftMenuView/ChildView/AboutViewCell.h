//
//  AboutViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewCell : UITableViewCell

@property(nonatomic,copy) NSString *leftString;
//@property(nonatomic,copy) NSString *rightString;
@property(nonatomic,strong) UILabel *rightLabel;

@property(nonatomic,strong) UIView *line;
@property(nonatomic,strong) UIImageView *upgradeImgView;


@end
