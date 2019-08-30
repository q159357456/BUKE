//
//  DeliveryTableViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    NO_Adress = 0,
    HAD_Adress
    
}CellStyle;
NS_ASSUME_NONNULL_BEGIN

@interface DeliveryTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *adressLabel;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,assign)CellStyle cellStyle;
@property(nonatomic,strong)NSDictionary *adressData;
@end

NS_ASSUME_NONNULL_END
