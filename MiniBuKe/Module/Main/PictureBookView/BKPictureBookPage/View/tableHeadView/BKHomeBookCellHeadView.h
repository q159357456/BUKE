//
//  BKHomeBookCellHeadView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BKHomeBookCellHeadViewRightBtnDelegate <NSObject>

@optional
-(void)homeTableHeaderViewRightBtnAction:(NSInteger)section;

@end

@interface BKHomeBookCellHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame andTitleStr:(NSString*)titleStr andSection:(NSInteger)section andisHideLine:(BOOL)ishide;

@property(nonatomic, weak) id <BKHomeBookCellHeadViewRightBtnDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
