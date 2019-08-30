//
//  TallkNotificationController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TallkNotificationController.h"
#import "TalkViewController.h"
#import "NotificationController.h"
#import "TalkNotificationNav.h"
#import "UIResponder+Event.h"
#import "BKMessageCtr.h"
#import "TalkPlaceHoderView.h"
#import "CommonUsePackaging.h"
#import "MusicPlayTool.h"

@interface TallkNotificationController ()<UIScrollViewDelegate>
@property(nonatomic,strong)BKMessageCtr *notificationController;
@property(nonatomic,strong)TalkViewController *talkViewController;
@property(nonatomic,strong)TalkNotificationNav *talkNotificationNav;
@property(nonatomic,strong)UIScrollView *scroView;
@property(nonatomic,strong)TalkPlaceHoderView * talkPlaceHoderView;
@end

@implementation TallkNotificationController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupChildVces];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.talkNotificationNav];
    [self.view addSubview:self.scroView];
   
    // Do any additional setup after loading the view.
    
}

-(TalkPlaceHoderView *)talkPlaceHoderView
{
    if (!_talkPlaceHoderView) {
        _talkPlaceHoderView = [[TalkPlaceHoderView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavbarH) Talk:Notifaction_Type];
    }
    return _talkPlaceHoderView;
}
-(UIScrollView *)scroView
{
    if (!_scroView) {
        _scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT - kNavbarH)];
        _scroView.contentSize = CGSizeMake(SCREEN_WIDTH*2, _scroView.bounds.size.height);
        _scroView.pagingEnabled = YES;
        _scroView.bounces = NO;
        _scroView.delegate = self;
        _scroView.scrollEnabled  =YES;
        _scroView.showsHorizontalScrollIndicator = NO;
    }
    return _scroView;
}
-(TalkNotificationNav *)talkNotificationNav
{
    if (!_talkNotificationNav) {
        _talkNotificationNav = [[TalkNotificationNav alloc]init];
    }
    return _talkNotificationNav;
}

- (void)setupChildVces
{
    kWeakSelf(weakSelf);
//    APP_DELEGATE.mLoginResult.SN = nil;
    if(APP_DELEGATE.mLoginResult.SN != nil && APP_DELEGATE.mLoginResult.SN.length > 0)
    {
        if (![self.childViewControllers containsObject:self.talkViewController]) {
            self.talkViewController = [[TalkViewController alloc] init];
            self.talkViewController.view.frame = CGRectMake(SCREEN_WIDTH, -kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.talkViewController.observeArray = self.observeArray;
            kWeakSelf(weakSelf);
            self.talkViewController.forbidBlock = ^(BOOL scroPremission) {
                weakSelf.scroView.scrollEnabled = scroPremission;
            };
            self.talkViewController.receiveMessageBlock = ^{
                if (weakSelf.scroView.contentOffset.x == 0) {
                    [weakSelf.talkNotificationNav setTalkBadge:NO];
                }
            };
            [self addChildViewController:self.talkViewController];
            [self.scroView addSubview:self.talkViewController.view];
        }
        
    }else
    {
        if ([self.childViewControllers containsObject:self.talkViewController])
        {
            [self.talkViewController removeFromParentViewController];
            [self.talkViewController.view removeFromSuperview];
        }
        if (![self.scroView.subviews containsObject:self.talkPlaceHoderView]) {
            [self.scroView addSubview:self.talkPlaceHoderView];
        }
        
    }
   
    if (![self.childViewControllers containsObject:self.notificationController]) {
        self.notificationController = [[BKMessageCtr alloc]init];
        [self.notificationController setChangeRedTip:^(BOOL isRed) {
            [weakSelf.talkNotificationNav setNotifactionBadge:isRed];
            if (isRed == NO && [weakSelf.talkNotificationNav GetTalkBadgeIsHide]) {
                [weakSelf scorllerToIndexPage:0];
            }
        }];
        [self addChildViewController:self.notificationController];
        self.notificationController.view.frame = self.scroView.bounds;
        [self.scroView addSubview:self.notificationController.view];
        
        if([CommonUsePackaging shareInstance].isMessageListNoticeRemind == YES && [CommonUsePackaging shareInstance].isShuoShuoListNoticeRemind == NO){
            [self scorllerToIndexPage:0];
        }else{
            [self scorllerToIndexPage:1];
        }
        [self.talkNotificationNav setTalkBadge:![CommonUsePackaging shareInstance].isShuoShuoListNoticeRemind];
        
        [CommonUsePackaging shareInstance].isMessageListNoticeRemind = NO;
        [CommonUsePackaging shareInstance].isShuoShuoListNoticeRemind = NO;
    }

}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    if (index==0) {
        if ([self.childViewControllers containsObject:self.talkViewController]) {
            [self.talkViewController stopPlay];
            [self.talkNotificationNav setTalkBadge:YES];
            [self.talkViewController stopVoiceAnimationing];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.talkNotificationNav animationWithOffset:scrollView.contentOffset.x];
}

-(void)eventName:(NSString *)eventname Params:(id)params
{
    if ([eventname isEqualToString:TalkNotificationNav_Event]) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.scroView setContentOffset:CGPointMake(SCREEN_WIDTH*[params integerValue], 0)];
        }];
    }
    if ([params intValue] == 0) {
        if ([self.childViewControllers containsObject:self.talkViewController]) {
            [self.talkViewController stopPlay];
             [self.talkNotificationNav setTalkBadge:YES];
            [self.talkViewController stopVoiceAnimationing];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)scorllerToIndexPage:(NSInteger)index{
    [self.talkNotificationNav animationTo:index];
    self.scroView.contentOffset = CGPointMake(SCREEN_WIDTH*index, 0);
}

@end
