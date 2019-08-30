//
//  DataColumnarView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Z_Y(y) self.frame.size.height - (y)
#define AngleToRadian(angle) (angle) * M_PI/180
#define with SCALE(35)
#define colum (SCREEN_WIDTH - 5*with)/6
NS_ASSUME_NONNULL_BEGIN

@interface DataColumnarView : UIView
-(instancetype)initWithFrame:(CGRect)frame Data:(NSArray*)data;
@property(nonatomic,strong)NSArray *timeDataArray;
@property(nonatomic,strong)NSMutableArray *layerArray;
@property(nonatomic,assign)BOOL isMinute;
@end

NS_ASSUME_NONNULL_END
