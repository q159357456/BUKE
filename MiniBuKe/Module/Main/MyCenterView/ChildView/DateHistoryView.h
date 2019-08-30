//
//  DateHistoryView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/24.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateHistoryView : UIView

+(instancetype) xibView;

-(void) updateDataView:(CGSize ) size setSeriesBookObjects:(NSArray *) mSeriesBookObjects;
@end
