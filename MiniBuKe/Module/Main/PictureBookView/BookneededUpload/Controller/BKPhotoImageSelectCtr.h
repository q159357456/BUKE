//
//  BKPhotoImageSelectCtr.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKPhotoImage.h"
#import "myPhotoCell.h"
#import "UIImage+fixOrientation.h"
#import "WPFunctionView.h"
#import "NavView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKPhotoImageSelectCtr : UIViewController

@property (assign, nonatomic) NSInteger selectPhotoOfMax;/**< 选择照片的最多张数 */

/** 回调方法 */
@property (nonatomic, copy) void(^selectPhotosBack)(NSMutableArray *photosArr);

@end

NS_ASSUME_NONNULL_END
