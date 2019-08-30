//
//  ScoreRemindView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/24.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreRemindView : UIView
@property(nonatomic,strong)void (^KownBlock)(void);
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title Info:(NSString*)info ImageName:(NSString*)imageName Block:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
