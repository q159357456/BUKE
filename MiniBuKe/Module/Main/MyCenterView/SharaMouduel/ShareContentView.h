//
//  ShareContentView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShareContentView : UIView
@property(nonatomic,copy)NSString *imageurl;
@property(nonatomic,strong)ShareImageModel * imageModel;
-(void)show;
-(void)hidden;

@end

NS_ASSUME_NONNULL_END
