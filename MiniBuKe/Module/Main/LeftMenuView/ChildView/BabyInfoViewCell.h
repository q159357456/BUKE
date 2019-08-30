//
//  BabyInfoViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/31.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BabyInfoViewCell : UITableViewCell

@property(nonatomic,copy) NSString *leftString;

@property(nonatomic,strong) UITextField *rightField;
@property(nonatomic,strong) UILabel *rightLabel;
@property(nonatomic,strong) UIView *line;
@end
