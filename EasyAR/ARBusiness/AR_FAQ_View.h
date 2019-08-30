//
//  AR_FAQ_View.h
//  MiniBuKe
//
//  Created by chenheng on 2019/5/13.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GuidanceVewCell;
@interface AR_FAQ_View : UIView
+(void)showFAQ;
@end

@interface GuidanceVewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * headImgV;
@property(nonatomic,strong)UILabel * label;
@end


NS_ASSUME_NONNULL_END
