//
//  IntensiveReadingController.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTMTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, CellStyle) {
    HTMTableViewCell_Style =0,
    IntensMoreBookViewCell_Style,
    IntensFootViewCell_Style,
    
};

@interface IntensiveReadingController : UIViewController
@property(nonatomic,copy)NSString *bookid;
@property(nonatomic,assign)Html_State html_State;
@property(nonatomic,assign)BOOL isScanningTo;
@end

NS_ASSUME_NONNULL_END
