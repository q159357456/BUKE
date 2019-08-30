//
//  BKRecordedLessonCell.h
//  MiniBuKe
//
//  Created by chenheng on 2019/7/22.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LineLessonsModel;
@interface BKRecordedLessonCell : UICollectionViewCell
- (void)setModelWith:(LineLessonsModel*)model;
@end

@interface LineLessonsTip : UILabel

@end
NS_ASSUME_NONNULL_END
