//
//  ScanningCodeView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *lightEvent = @"lightEvent";
static NSString *photoGraphEvent = @"photoGraphEvent";
#define ScanningCodeView_Event @"ScanningCodeView_Event"
typedef NS_ENUM(NSUInteger, FuncMode) {
    ScanCodeMode = 0,
    Photograph
};
@interface ScanningCodeView : UIView
@property(nonatomic,strong)UILabel *promptLabel;
@property(nonatomic,assign)FuncMode funcMode;
+ (instancetype)scanningQRCodeViewWithFrame:(CGRect)frame outsideViewLayer:(UIView *)outsideViewLayer;
@end

NS_ASSUME_NONNULL_END
