//
//  DataLineView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataLineView : UIView
@property(nonatomic,strong)NSMutableArray *layerArray;
@property(nonatomic,strong)NSMutableArray *b_layerArray;
@property(nonatomic,strong)NSArray *dataArray;
-(instancetype)initWithFrame:(CGRect)frame Data:(NSArray*)data;
@end

NS_ASSUME_NONNULL_END
