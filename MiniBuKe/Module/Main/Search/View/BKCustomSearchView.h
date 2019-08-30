//
//  BKCustomSearchView.h
//  MiniBuKe
//
//  Created by chenheng on 2019/1/8.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BKCustomSearchViewDelegate <NSObject>

- (void)SearchFiledTextChange:(NSString*)changeStr;
- (void)SearchDoneWithText:(NSString*)searchStr;

@end

@interface BKCustomSearchView : UIView

@property (weak, nonatomic, nullable) id<BKCustomSearchViewDelegate> delegate;

- (void)changeBecomeFirstResponder;
- (void)changeResignFirstResponder;

- (void)changeAnimationUI;

- (void)changeTheTextWithStr:(NSString*)str;

@end

NS_ASSUME_NONNULL_END
