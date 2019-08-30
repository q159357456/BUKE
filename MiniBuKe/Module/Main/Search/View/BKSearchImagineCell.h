//
//  BKSearchImagineCell.h
//  MiniBuKe
//
//  Created by chenheng on 2019/1/9.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKSearchImagineCell : BKBaseTableViewCell

- (void)setModelWithTitle:(NSString*)title andHightTitle:(NSString*)hightTitle;

//改变高亮选中UI
- (void)changeTheHighlightedUI:(BOOL)isHigh;

@end

NS_ASSUME_NONNULL_END
