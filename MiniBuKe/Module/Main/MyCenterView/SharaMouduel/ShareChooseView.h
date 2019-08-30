//
//  ShareChooseView.h
//  MiniBuKe
//
//  Created by chenheng on 2019/7/23.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareChooseView : UIView
+(instancetype)shareChooseCallBack:(void(^)(NSInteger index))callBack;
@end

NS_ASSUME_NONNULL_END
