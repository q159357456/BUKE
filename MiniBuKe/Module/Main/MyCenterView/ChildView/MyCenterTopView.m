//
//  MyCenterTopView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "MyCenterTopView.h"
#import "BabyBookViewController.h"
#import "KBookPlayListViewController.h"
#import "StoryCollectViewController.h"
#import "RecentlyPlayViewController.h"
#import "StoryPlayListViewController.h"
#import "BindMaskViewController.h"
#import "ListenerCollectViewController.h"
#import "RecentlyPlayNewViewController.h"
#import "KBookListViewController.h"
#import "BKRobotBindTipCtr.h"

@interface MyCenterTopView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mNumberLabel;

@end

@implementation MyCenterTopView

+(instancetype)xibView {
    return [[[NSBundle mainBundle] loadNibNamed:@"MyCenterTopView" owner:nil options:nil] lastObject];
}

-(void) updateDataView:(NSString *)title setIcon:(NSString *) icon setNumber:(NSString *) number
{
    self.imageLabel.layer.cornerRadius = self.imageLabel.frame.size.width/9.9;
    self.imageLabel.layer.masksToBounds = YES;
    [self.imageLabel setImage:[UIImage imageNamed: icon]];
    self.mTitleLabel.text = title;
    self.mNumberLabel.text = number;
}

-(IBAction) onClickButton:(id)sender
{
    NSLog(@"===> MyCenterTopView ClickButton <====");
    if ([@"宝宝书架" isEqualToString:self.mTitleLabel.text]) {
        
        if(APP_DELEGATE.mLoginResult.SN != nil && APP_DELEGATE.mLoginResult.SN.length > 0){
            BabyBookViewController *mBabyBookViewController = [[BabyBookViewController alloc] init];
            [APP_DELEGATE.navigationController pushViewController:mBabyBookViewController animated:YES];
            
//            [MobClick event:EVENT_BABY_RACK_13];
        } else {
//            [BindMaskViewController pushViewController];
            BKRobotBindTipCtr *ctr = [[BKRobotBindTipCtr alloc]init];
            [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
        }
        
    } else if ([@"K绘本" isEqualToString:self.mTitleLabel.text]) {
        
        KBookListViewController *kbookListVC = [[KBookListViewController alloc] init];
        [APP_DELEGATE.navigationController pushViewController:kbookListVC animated:YES];
        
//        [MobClick event:EVENT_K_BOOK_15];
        
//        KBookPlayListViewController *mKBookPlayListViewController = [[KBookPlayListViewController alloc] init];
//        [APP_DELEGATE.navigationController pushViewController:mKBookPlayListViewController animated:YES];
    } else if ([@"听听收藏" isEqualToString:self.mTitleLabel.text]) {
        
        StoryPlayListViewController *playListVC = [[StoryPlayListViewController alloc]init];

//        playListVC.listModel = listModel;
        playListVC.sourceType = StoryPlaySourceType_Collect;

        [APP_DELEGATE.navigationController pushViewController:playListVC animated:YES];
        
//        [MobClick event:EVENT_LISTENT_COLLECT_14];
//        ListenerCollectViewController *mListenerCollectViewController = [[ListenerCollectViewController alloc]init];
//        [APP_DELEGATE.navigationController pushViewController:mListenerCollectViewController animated:YES];
        
    } else if ([@"最近播放" isEqualToString:self.mTitleLabel.text]) {
        
        StoryPlayListViewController *playListVC = [[StoryPlayListViewController alloc]init];

        //        playListVC.listModel = listModel;
        playListVC.sourceType = StoryPlaySourceType_Recent;

        [APP_DELEGATE.navigationController pushViewController:playListVC animated:YES];
        
//        [MobClick event:EVENT_RECENTLY_PLAY_16];
        
//        RecentlyPlayNewViewController *mRecentlyPlayNewViewController = [[RecentlyPlayNewViewController alloc]init];
//        [APP_DELEGATE.navigationController pushViewController:mRecentlyPlayNewViewController animated:YES];
    }
    
}

@end
