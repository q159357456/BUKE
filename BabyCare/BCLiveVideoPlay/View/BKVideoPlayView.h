//
//  BKVideoPlayView.h
//  babycaretest
//
//  Created by Don on 2019/4/24.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  BKVideoPlayViewDelegate <NSObject>
//大小屏切换代理方法
- (void)playViewSwitchOrientationWithIsFull:(BOOL)isFull;
//返回按钮点击代理方法
- (void)playViewBackBtnClick;
//右上角菜单点击代理方法
- (void)playViewMenuBtnClick:(UIButton*)btn;
//声音按钮点击代理方法
- (void)playViewVolumeClickWithIsOpen:(BOOL)isOpen;
//通话按钮选中代理
- (void)playViewTalkClickWithIsOpen:(BOOL)isOpen;
//截图按钮代理
- (void)playViewSnapClick;
//播放按钮代理
- (void)playViewPlayBtnClikWithIsOpen:(BOOL)isOpen;
//全屏手势代理
- (void)playFullViewTap:(BOOL)isShow;

@optional
//屏幕切换,view frame 改变
- (void)playViewFrameHasChanged;

@end
NS_ASSUME_NONNULL_BEGIN

@interface BKVideoPlayView : UIView
/* 代理 */
@property (nonatomic, assign) id<BKVideoPlayViewDelegate>delegate;

@property (nonatomic, strong) UIImageView *showView; //图像显示View
//是否全屏显示
@property(nonatomic,assign)BOOL isFullView;

//显示或者隐藏全屏按钮
- (void)showToolView:(BOOL)isShow;
//改变系统菊花loading
- (void)ActionLoadingChange:(BOOL)isLoading;
/**同步播放器按钮状态*/
- (void)changeTheUIStateWithIsShow:(BOOL)isShow;
- (void)changeTheUIStateWithIsLising:(BOOL)isListen;
- (void)changeTheUIStateWithIsTalk:(BOOL)isTalk;

- (void)defaultSetShowView;
//在线离线状态显示按钮.
- (void)changeTheContentStateShowLabel:(BOOL)isOnline andIsShow:(BOOL)isshow;
/**获取静音按钮的选中状态(选中:静音)*/
- (BOOL)GetTheVolumBtnSelectState;

- (BOOL)GetThePlayBtnhide;

- (void)cancelFullScreen;

@end

NS_ASSUME_NONNULL_END
