//
//  IntensTableViewHeader.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IntensTableViewHeader_Event @"IntensTableViewHeader_Event"
#define IntensTableViewHeader_Height 50
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, Intensive_Style) {
    Intensive_Mode,
    Comme_Mode,
};
@interface IntensTableViewHeader : UIView
-(instancetype)initWithFrame:(CGRect)frame Intensive:(Intensive_Style)intensive;
@property(nonatomic,assign)Intensive_Style  intensive_Style;
-(void)animationTo:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
