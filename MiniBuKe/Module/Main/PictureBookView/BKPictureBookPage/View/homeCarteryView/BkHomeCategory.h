//
//  BkHomeCategory.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BkHomeCategoryDelegate <NSObject>

-(void)CategoryBtnClick:(int)type;

@end

@interface BkHomeCategory : UIView

- (void)setImageURl:(NSString*)url andTitle:(NSString*)title;

@property(nonatomic,assign) id<BkHomeCategoryDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
