//
//  BKVideoPlayView.m
//  babycaretest
//
//  Created by Don on 2019/4/24.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKVideoPlayView.h"
#import "Masonry.h"
#import "BKCameraManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BKVideoCustomVolumeView.h"

#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, //横向移动
    PanDirectionVerticalMoved    //纵向移动
};

@interface BKVideoPlayView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *fullScreenBtn;//全屏按钮
@property (nonatomic, strong) UIButton *bigPlayBtn;//大播放按钮
@property (nonatomic, strong) UIButton *volumeBtn;//静音按钮
@property (nonatomic, strong) UIButton *smallPlayBtn;//小播放按钮
@property (nonatomic, strong) UIButton *snapScreenBtn;//截屏按钮
@property (nonatomic, strong) UIButton *talkBtn;//通话按钮
@property (nonatomic, strong) UILabel *talkshowLabel;//通话提示
@property (nonatomic, strong) UIButton *backBtn;//返回按钮
@property (nonatomic, strong) UIButton *menuBtn;//菜单按钮
@property (nonatomic, strong) UIButton *connectStateBtn;//状态显示按钮

/** 系统菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property(nonatomic, strong) UIPanGestureRecognizer *pan;
@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) PanDirection panDirection;

/** 音量滑杆 */
@property (nonatomic, strong) UISlider  *volumeViewSlider;
@property (nonatomic, strong) BKVideoCustomVolumeView *volumeView;
@property (nonatomic, strong) BKVideoCustomVolumeView *brightView;

@property (nonatomic, assign) BOOL toolViewIsShow;//工具栏是否隐藏
@property (nonatomic, assign) BOOL Istalking;

@end

@implementation BKVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(void)defaultSetShowView{
    self.showView.image = [UIImage imageNamed:@"bc_videoBG"];
    [self changeTheContentStateShowLabel:NO andIsShow:YES];
}

//初始化UI
- (void)setupUI{
    self.backgroundColor = [UIColor blackColor];
    self.toolViewIsShow = YES;
    
    self.showView = [[UIImageView alloc]init];
    self.showView.image = [UIImage imageNamed:@"bc_videoBG"];
    [self addSubview:self.showView];
    
    self.fullScreenBtn = [[UIButton alloc]init];
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"bc_full_icon"] forState:UIControlStateNormal];
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"bc_tran_full_icon"] forState:UIControlStateSelected];
    [self.fullScreenBtn addTarget:self action:@selector(fullBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.fullScreenBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [self addSubview:self.fullScreenBtn];
    
    self.bigPlayBtn = [[UIButton alloc]init];
    [self.bigPlayBtn setImage:[UIImage imageNamed:@"bc_play_big_icon"] forState:UIControlStateNormal];
    [self.bigPlayBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bigPlayBtn];

    self.smallPlayBtn = [[UIButton alloc]init];
    [self.smallPlayBtn setImage:[UIImage imageNamed:@"bc_play_icon"] forState:UIControlStateNormal];
    [self.smallPlayBtn setImage:[UIImage imageNamed:@"bc_stop_icon"] forState:UIControlStateSelected];
    [self.smallPlayBtn addTarget:self action:@selector(smallplayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.smallPlayBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [self addSubview:self.smallPlayBtn];
    
    self.snapScreenBtn = [[UIButton alloc]init];
    [self.snapScreenBtn setImage:[UIImage imageNamed:@"bc_tran_cute_icon"] forState:UIControlStateNormal];
    [self.snapScreenBtn addTarget:self action:@selector(snapScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.snapScreenBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [self addSubview:self.snapScreenBtn];

    self.volumeBtn = [[UIButton alloc]init];
    [self.volumeBtn setImage:[UIImage imageNamed:@"bc_volume_icon"] forState:UIControlStateNormal];
    [self.volumeBtn setImage:[UIImage imageNamed:@"bc_tran_quitel_icon"] forState:UIControlStateSelected];
    [self.volumeBtn addTarget:self action:@selector(volumeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.volumeBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [self addSubview:self.volumeBtn];
    
    self.talkBtn = [[UIButton alloc]init];
    [self.talkBtn setImage:[UIImage imageNamed:@"bc_tran_call_icon"] forState:UIControlStateNormal];
    [self.talkBtn setImage:[UIImage imageNamed:@"bc_tran_hang_up_icon"] forState:UIControlStateSelected];
    [self.talkBtn addTarget:self action:@selector(talkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.talkBtn];
    
    self.talkshowLabel = [[UILabel alloc]init];
    self.talkshowLabel.textColor = [UIColor whiteColor];
    self.talkshowLabel.textAlignment = NSTextAlignmentCenter;
    self.talkshowLabel.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:self.talkshowLabel];
    
    self.backBtn = [[UIButton alloc]init];
    [self.backBtn setImage:[UIImage imageNamed:@"bc_back_icon"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backBtn];
    
    self.menuBtn = [[UIButton alloc]init];
    [self.menuBtn setImage:[UIImage imageNamed:@"bc_menu"] forState:UIControlStateNormal];
    [self.menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.menuBtn];

    self.connectStateBtn = [[UIButton alloc]init];
    [self.connectStateBtn setImage:[UIImage imageNamed:@"bc_connectState_offline"] forState:UIControlStateNormal];
    [self.connectStateBtn setTitle:@"离线" forState:UIControlStateNormal];
    [self.connectStateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.connectStateBtn.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:0.6];
    self.connectStateBtn.layer.cornerRadius = 10;
    self.connectStateBtn.clipsToBounds = YES;
    self.connectStateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.connectStateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    self.connectStateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
    [self addSubview:self.connectStateBtn];

    self.volumeView = [[BKVideoCustomVolumeView alloc]initWithVolumeOrLight:0];
    self.volumeView.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:0.5];
    self.volumeView.layer.cornerRadius = 15;
    self.volumeView.clipsToBounds = YES;
    self.volumeView.alpha = 0;
    [self addSubview:self.volumeView];
    
    self.brightView =  [[BKVideoCustomVolumeView alloc]initWithVolumeOrLight:1];
    self.brightView.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:0.5];
    self.brightView.layer.cornerRadius = 15;
    self.brightView.clipsToBounds = YES;
    self.brightView.alpha = 0;
    [self addSubview:self.brightView];

    //系统菊花
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activity.frame = CGRectMake(0, 0, 40, 40);
    [self addSubview:self.activity];

    [self addGestures];

}

//系统音量回调
- (void)volumeChangeNotification:(NSNotification *)noti {
//    NSLog(@"%@",[noti.userInfo objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"]);
    if([[noti.userInfo objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"] isEqualToString:@"PhoneCall"]){
        return;
    }else if ([[noti.userInfo objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"] isEqualToString:@"Audio/Video"]){
        
        float volume = [[[noti userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
        self.volumeView.alpha = 1;
        [self.volumeView changeTheProgress:volume];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIImageView animateWithDuration:2 animations:^{
                self.volumeView.alpha = 0;
            }];
        });
    }
}
#pragma mark - 界面布局
- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
    [self changeTheBtnShow:self.isFullView];
    if (!self.isFullView) { //小屏
        
        [self.showView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(weakSelf);
        }];
        [self.bigPlayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(60);
            make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
            make.centerY.equalTo(weakSelf.mas_centerY).offset(0);
        }];
        [self.volumeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(44);
            make.left.equalTo(weakSelf.mas_left).offset(15-6);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-12+6);
        }];
        [self.fullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(44);
            make.right.equalTo(weakSelf.mas_right).offset(-15+6);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-12+6);
        }];
        [self.snapScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(44);
            make.right.equalTo(weakSelf.fullScreenBtn.mas_left).offset(-15+6);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-6);
        }];
        [self.smallPlayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(0);
            make.top.equalTo(weakSelf.mas_bottom).offset(0);
            make.right.equalTo(weakSelf.mas_right).offset(0);
        }];
        [self.talkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(0);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
            make.left.equalTo(weakSelf.mas_left).offset(0);
        }];
        [self.talkshowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(0);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
            make.left.equalTo(weakSelf.mas_left).offset(0);
        }];

    }else{//全屏
        
        CGFloat offset = (kScreenWidth -(kScreenHeight)*(4.0/3))*0.5;
        [self.showView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top).offset(0);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
            make.left.equalTo(weakSelf.mas_left).offset(offset);
            make.right.equalTo(weakSelf.mas_right).offset(-offset);
        }];
        [self.bigPlayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(90);
            make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
            make.centerY.equalTo(weakSelf.mas_centerY).offset(0);
        }];
        [self.snapScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40+12);
            make.bottom.equalTo(weakSelf.mas_centerY).offset(-13+6);
            make.right.equalTo(weakSelf.mas_right).offset(-22+6);
        }];
        [self.volumeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40+12);
            make.bottom.equalTo(weakSelf.snapScreenBtn.mas_top).offset(-26+6);
            make.right.equalTo(weakSelf.mas_right).offset(-22+6);
        }];
        [self.fullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40+12);
            make.top.equalTo(weakSelf.mas_centerY).offset(13-6);
            make.right.equalTo(weakSelf.mas_right).offset(-22+6);
        }];
        [self.smallPlayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40+12);
            make.top.equalTo(weakSelf.fullScreenBtn.mas_bottom).offset(26-6);
            make.right.equalTo(weakSelf.mas_right).offset(-22+6);
        }];
        [self.talkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(60);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-58);
            make.left.equalTo(weakSelf.mas_left).offset(offset-30-7);
        }];
        [self.talkshowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(20);
            make.top.equalTo(weakSelf.talkBtn.mas_bottom).offset(5);
            make.centerX.equalTo(weakSelf.talkBtn.mas_centerX).offset(0);
        }];
    }
    
    [self.volumeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
        make.top.equalTo(weakSelf.mas_top).offset(60);
    }];
    [self.brightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
        make.top.equalTo(weakSelf.mas_top).offset(60);
    }];

    [self.activity mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.showView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.showView.mas_centerY);
    }];
    
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(45);
        make.top.equalTo(weakSelf.mas_top).offset(kStatusBarH);
        make.left.equalTo(weakSelf.mas_left).offset(0);
    }];
    
    [self.connectStateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(61);
        make.height.mas_equalTo(21);
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.top.equalTo(weakSelf.backBtn.mas_bottom).offset(5);
    }];
    
    [self.menuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(45);
        make.top.equalTo(weakSelf.mas_top).offset(kStatusBarH);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
    }];
    
    [self frameIsChangeAction];
}

- (void)changeTheBtnShow:(BOOL)isfull{
    self.smallPlayBtn.hidden = !isfull;
    self.talkBtn.hidden = !isfull;
    self.talkshowLabel.hidden = !isfull;
    self.volumeView.hidden = !isfull;
    self.brightView.hidden = !isfull;
    self.talkBtn.hidden = !self.bigPlayBtn.selected;
    self.menuBtn.hidden = isfull;
}

- (void)frameIsChangeAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playViewFrameHasChanged)]) {
        [self.delegate playViewFrameHasChanged];
    }
}
#pragma mark - btn Click
- (void)fullBtnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    self.isFullView = btn.selected;
    
    [self changeTheFullScreenIfFull:self.isFullView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playViewSwitchOrientationWithIsFull:)]) {
        [self.delegate playViewSwitchOrientationWithIsFull:btn.selected];
    }
    
}

- (void)playBtnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    btn.hidden = btn.selected;
    self.smallPlayBtn.selected = btn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playViewPlayBtnClikWithIsOpen:)]) {
        [self.delegate playViewPlayBtnClikWithIsOpen:btn.selected];
    }
    self.talkBtn.hidden = !self.bigPlayBtn.selected;
}

-(void)smallplayBtnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    self.bigPlayBtn.selected = btn.selected;
    self.bigPlayBtn.hidden = btn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playViewPlayBtnClikWithIsOpen:)]) {
        [self.delegate playViewPlayBtnClikWithIsOpen:btn.selected];
    }
    self.talkBtn.hidden = !self.bigPlayBtn.selected;
}

- (void)snapScreenBtnClick:(UIButton*)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playViewSnapClick)]) {
        [self.delegate playViewSnapClick];
    }
}

- (void)volumeBtnClick:(UIButton*)btn{
//    if(self.bigPlayBtn.selected){
        btn.selected = !btn.selected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(playViewVolumeClickWithIsOpen:)]) {
            [self.delegate playViewVolumeClickWithIsOpen:btn.selected];
        }
//    }
}

- (void)talkBtnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.talkshowLabel.text = @"正在连接中...";
    }else{
        self.talkshowLabel.text = @"";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(playViewTalkClickWithIsOpen:)]) {
        [self.delegate playViewTalkClickWithIsOpen:btn.selected];
    }
}

- (void)backBtnClick:(UIButton*)btn{
    if (self.isFullView) {//全屏
        [self fullBtnClick:self.fullScreenBtn];
    }else{//小屏
        if (self.delegate && [self.delegate respondsToSelector:@selector(playViewBackBtnClick)]) {
            [self.delegate playViewBackBtnClick];
        }
    }
}

- (void)menuBtnClick:(UIButton*)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playViewMenuBtnClick:)]) {
        [self.delegate playViewMenuBtnClick:btn];
    }
}

#pragma mark - 播放器手势
/**
*  添加播放器手势操作
*/
-(void)addGestures{
    if (self.tapGesture == nil) {
        
        self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        _tapGesture.delegate = self;
    }
    [self addGestureRecognizer:_tapGesture];
}

- (void)tapAction:(UITapGestureRecognizer*)tap{
    if (self.isFullView) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(playFullViewTap:)]) {
            [self.delegate playFullViewTap:!self.toolViewIsShow];
        }
    }else{
        
        if (self.bigPlayBtn.hidden) {
            CGPoint locationPoint = [tap locationInView:self];
            if (CGRectContainsPoint(CGRectMake(self.bigPlayBtn.frame.origin.x-10, self.bigPlayBtn.frame.origin.y-10, self.bigPlayBtn.frame.size.width+10, self.bigPlayBtn.frame.size.height+10),locationPoint)) {
                
                [self playBtnClick:self.bigPlayBtn];
            }
        }
    }
}

- (void)panDirection:(UIPanGestureRecognizer *)pan
{
    if (!self.isFullView || !self.bigPlayBtn.selected) {
        return;
    }
    //    //根据在view上Pan的位置
    CGPoint locationPoint = [pan locationInView:self];
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    if (!CGRectContainsPoint(self.frame,locationPoint)) {
        return;
    }
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                self.panDirection           = PanDirectionHorizontalMoved;
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                if (CGRectContainsPoint(CGRectMake(0, 0, kScreenWidth*0.5, kScreenHeight),locationPoint)) {
                    self.volumeView.alpha = 0;
                }else{
                    self.brightView.alpha = 0;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    break;
                }
                case PanDirectionVerticalMoved:{
                    if (CGRectContainsPoint(CGRectMake(0, 0, kScreenWidth*0.5, kScreenHeight),locationPoint)) {
                        //亮度变化
                        [self verticalMovedBright:veloctyPoint.y];
                    }else{
                        //音量t变化
                        [self verticalMovedVolume:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量,隐藏音量条
                    if (CGRectContainsPoint(CGRectMake(0, 0, kScreenWidth*0.5, kScreenHeight),locationPoint)) {
                        //亮度变化
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [UIImageView animateWithDuration:2 animations:^{
                                self.brightView.alpha = 0;
                            }];
                        });
                    }else{
                        //音量变化
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [UIImageView animateWithDuration:2 animations:^{
                                self.volumeView.alpha = 0;
                            }];
                        });
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)verticalMovedVolume:(CGFloat)value
{
    if (self.Istalking) {
        return;
    }
    self.brightView.alpha = 0;
    //显示音量条
    self.volumeView.alpha = 1;
    // 更改系统的音量
    self.volumeViewSlider.value      -= value / 10000;
}

- (void)verticalMovedBright:(CGFloat)value{
    self.volumeView.alpha = 0;
    self.brightView.alpha = 1;
    float currentValue = [UIScreen mainScreen].brightness;
    currentValue -= value / 10000;
    [[UIScreen mainScreen] setBrightness:currentValue];
    [self.brightView changeTheProgress:currentValue];
}

-(void)getVolumeVolue
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    self.volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider *)view;
            [self addSubview:self.volumeViewSlider];
            break;
        }
    }
    self.volumeViewSlider.frame = CGRectMake(-400, -400, 100, 100);
    self.volumeViewSlider.hidden = NO;
    
    /* 马上获取不到值 */
    [self performSelector:@selector(afterOneSecond) withObject:nil afterDelay:1];
}

-(void)afterOneSecond
{
    [self.volumeView changeTheProgress:self.volumeViewSlider.value];
    [self.brightView changeTheProgress:[UIScreen mainScreen].brightness];
}

#pragma mark - 全屏切换
- (void)changeTheFullScreenIfFull:(BOOL)isfull{
    //大屏添加pan手势，小屏取消pan手势
    if(self.isFullView){
        [self getVolumeVolue];
        //监听系统音量变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChangeNotification:)name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
        self.volumeViewSlider.hidden = NO;

        if (self.pan == nil) {
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
            pan.delegate = self;
            self.pan = pan;
        }
        [self addGestureRecognizer:_pan];
        
    }else{
        
        [self.volumeViewSlider removeFromSuperview];
        self.volumeViewSlider.hidden = NO;
        self.volumeViewSlider = nil;
        
        [self removeGestureRecognizer:_pan];
        
        //移除监听系统音量变化
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    }
}

#pragma mark - public
//显示或者隐藏全屏按钮
- (void)showToolView:(BOOL)isShow
{
    if(isShow != self.toolViewIsShow){
        
        [UIView animateWithDuration:1.0 animations:^{
            self.fullScreenBtn.alpha = isShow;
            self.snapScreenBtn.alpha = isShow;
            self.smallPlayBtn.alpha = isShow;
            self.volumeBtn.alpha = isShow;
            self.backBtn.alpha = isShow;
        }];
        self.toolViewIsShow = isShow;
    }
}

-(void)ActionLoadingChange:(BOOL)isLoading{

    dispatch_async(dispatch_get_main_queue(), ^{
        if (isLoading) {
            if (self.bigPlayBtn.selected) {
                [self.activity startAnimating];
            }
        }else{
            [self.activity stopAnimating];
        }
    });

}
/**同步播放器按钮状态*/
-(void)changeTheUIStateWithIsShow:(BOOL)isShow{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bigPlayBtn.selected = isShow;
        self.bigPlayBtn.hidden = isShow;
        self.smallPlayBtn.selected = isShow;
        if (self.bigPlayBtn.selected == NO) {
            [self ActionLoadingChange:NO];
        }
        self.talkBtn.hidden = !self.bigPlayBtn.selected;
    });
}
-(void)changeTheUIStateWithIsLising:(BOOL)isListen{
    
}
-(void)changeTheUIStateWithIsTalk:(BOOL)isTalk{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.talkBtn.selected = isTalk;
        self.Istalking = isTalk;
        if (isTalk) {
            self.talkshowLabel.text = @"正在和设备通话";
        }else{
            self.talkshowLabel.text = @"";
        }
    });
}

- (void)changeTheContentStateShowLabel:(BOOL)isOnline andIsShow:(BOOL)isshow{
    self.connectStateBtn.hidden = !isshow;
    if (isOnline) {
        [self.connectStateBtn setImage:[UIImage imageNamed:@"bc_connectState_online"] forState:UIControlStateNormal];
        [self.connectStateBtn setTitle:@"在线" forState:UIControlStateNormal];
    }else{
        [self.connectStateBtn setImage:[UIImage imageNamed:@"bc_connectState_offline"] forState:UIControlStateNormal];
        [self.connectStateBtn setTitle:@"离线" forState:UIControlStateNormal];
    }
}
- (BOOL)GetTheVolumBtnSelectState{
    return self.volumeBtn.isSelected;
}
- (BOOL)GetThePlayBtnhide{
    return self.bigPlayBtn.hidden;
}

- (void)cancelFullScreen{
    if (_fullScreenBtn.selected) {
        [self fullBtnClick:_fullScreenBtn];
    }
}

@end
