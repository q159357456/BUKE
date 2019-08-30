//
//  MyCenterTopView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCenterTopView : UIView

+(instancetype) xibView;

-(void) updateDataView:(NSString *)title setIcon:(NSString *) icon setNumber:(NSString *) number;
@end
