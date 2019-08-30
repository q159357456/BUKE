//
//  GuidanceVew.h
//  MiniBuKe
//
//  Created by chenheng on 2019/5/13.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuidanceVew : UIView
+(instancetype)showGuidInfo:(NSArray*)imageList Describ:(NSString*)describ CallBack:(void(^)(NSInteger index))block;
-(void)showBuyMember:(BOOL)is;
@end



NS_ASSUME_NONNULL_END
