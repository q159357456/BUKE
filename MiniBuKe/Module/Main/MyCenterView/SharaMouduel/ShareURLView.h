//
//  ShareURLView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShareURLView : UIView
@property(nonatomic,strong)ShareModel *model;
@property(nonatomic,strong)ShareURLModel * urlModel;
-(void)show;
-(void)hidden;
@end

NS_ASSUME_NONNULL_END
