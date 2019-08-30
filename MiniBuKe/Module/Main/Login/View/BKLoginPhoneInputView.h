//
//  BKLoginPhoneInputView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKLoginPhoneInputView : UIView

-(void)startFirstResponder;
-(void)cancelFirstResponder;

@property (nonatomic, copy) void(^areaSelectBlock)(void);

/**改变地区区号*/
- (void)changeThePhoneArea:(NSString*)str;
- (void)changeThePhoneNumber:(NSString*)str;

- (NSString*)GetThePhoneAreaNUmber;

@end

NS_ASSUME_NONNULL_END
