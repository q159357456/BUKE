//
//  ARRecognitionView.h
//  MiniBuKe
//
//  Created by chenheng on 2019/4/25.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARManager.h"
NS_ASSUME_NONNULL_BEGIN
#define TOP_HEIGHT kNavbarH
#define BOTTOM_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height>=44?84:50)
@interface ARRecognitionView : UIView
@property(nonatomic,strong)UIImageView *bgView;

@property(nonatomic,strong)UIImageView *readingImageView;
@property(nonatomic,strong)UIImageView *waitingImageView;
@property(nonatomic,strong)UIImageView *erroImageView;
@property(nonatomic,strong)UIImageView *HitPagingImageView;
@property(nonatomic,strong)UIImageView *downLoadingImageView;
@property(nonatomic,strong)UIImageView *downSucessImageView;
@property(nonatomic,strong)UIImageView *downFailedImageView;
@property(nonatomic,assign)NSInteger animationIndex;
+(instancetype)singleton;
- (void)start;
- (void)stop;
//读书动画
-(void)startReadingAnimation;
//等待动画
-(void)startWaitingAnimation;
//报错动画
-(void)startErroAnimamation;
//提示翻页动画
-(void)startHintPagingAnimation;
//下载动画
-(void)startDownLoadingAnimation;
//下载成功动画
-(void)startDownLoadSuccessAnimation;
//下载失败动画
-(void)startDownLoadFaildAnamation;


////继续动画
-(void)startAnimation;
//停止动画
-(void)stopAndHiddenOtherAnimation;
//
-(void)goToCamaraPremission;
//
-(void)stopARAndAnimation;





@end

NS_ASSUME_NONNULL_END
