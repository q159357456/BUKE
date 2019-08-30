//
//  RecommandView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecommandView : UIView
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title;
@property(nonatomic ,assign)NSInteger starCount;
@end

NS_ASSUME_NONNULL_END
