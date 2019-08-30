//
//  BookneededScanningCodeVC.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, Session_Style) {
    Code_Session = 0,
    PhotoGraph_Session
};
@interface BookneededScanningCodeVC : UIViewController
@property(nonatomic,assign)Session_Style session_Style;
@end

NS_ASSUME_NONNULL_END
