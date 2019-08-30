//
//  BKCenterBtnListCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCenterBtnListCell.h"
#import "BKMyBtton.h"
#import "BabyBookViewController.h"
#import "KBookListViewController.h"
#import "StoryPlayListViewController.h"
#import "RecentPlayViewController.h"
@implementation BKCenterBtnListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        NSArray *titleArray = @[@"宝宝书架",@"k绘本",@"听听收藏",@"最近播放"];
        NSArray *imageArray = @[@"bookshelf_icon",@"kbook_icon",@"collection_icon",@"lately_icon"];
        
        for (NSInteger i=0; i<4; i++) {
            CGFloat width = SCALE(346)/4;
            BKMyBtton *btn = [[BKMyBtton alloc]initWithFrame:CGRectMake(i*width, 0, width, SCALE(90)) ImageFrame:CGRectMake(SCALE(29), SCALE(22), SCALE(30), SCALE(30)) TitleFrame:CGRectMake(0, SCALE(60), width, SCALE(13))];
//            btn.backgroundColor = [UIColor redColor];
            btn.titleImage.image = [UIImage imageNamed:imageArray[i]];
            btn.contentText.text = titleArray[i];
            btn.contentText.font = [UIFont systemFontOfSize:14];
            
            [self.contentView addSubview:btn];
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i + 100;
        }
    }
    return self;
}

-(void)onClick:(UIButton*)btn{
    
    switch (btn.tag - 100) {
        case 0:
        {
            if(4 == [APP_DELEGATE.snData.type integerValue]){
                //babycare不支持提示
                ScoreRemindView *reminde =[[ScoreRemindView alloc]initWithFrame:[UIScreen mainScreen].bounds Title:@"此设备暂不支持该功能" Info:@"" ImageName:@"bc_DontUse_tip" Block:^{
                    
                }];
                [APP_DELEGATE.window addSubview:reminde];
            }else{
                BabyBookViewController *mBabyBookViewController = [[BabyBookViewController alloc] init];
                [APP_DELEGATE.navigationController pushViewController:mBabyBookViewController animated:YES];
                //                [MobClick event:EVENT_BABY_RACK_13];
                [[BaiduMobStat defaultStat] logEvent:@"e_myJump100" eventLabel:@"宝宝书架"];
            }
         

        }
            break;
            
        case 1:
        {
            if (4 == [APP_DELEGATE.snData.type integerValue]) {
                //babycare不支持提示
                ScoreRemindView *reminde =[[ScoreRemindView alloc]initWithFrame:[UIScreen mainScreen].bounds Title:@"此设备暂不支持该功能" Info:@"" ImageName:@"bc_DontUse_tip" Block:^{
                    
                }];
                [APP_DELEGATE.window addSubview:reminde];
            }else{
                KBookListViewController *kbookListVC = [[KBookListViewController alloc] init];
                [APP_DELEGATE.navigationController pushViewController:kbookListVC animated:YES];
                
                //            [MobClick event:EVENT_K_BOOK_15];
                [[BaiduMobStat defaultStat] logEvent:@"e_myJump100" eventLabel:@"K绘本"];
            }

        }
            break;
        case 2:
        {
            StoryPlayListViewController *playListVC = [[StoryPlayListViewController alloc]init];
            
            //        playListVC.listModel = listModel;
            playListVC.sourceType = StoryPlaySourceType_Collect;
            
            [APP_DELEGATE.navigationController pushViewController:playListVC animated:YES];
            
//            [MobClick event:EVENT_LISTENT_COLLECT_14];
            [[BaiduMobStat defaultStat] logEvent:@"e_myJump100" eventLabel:@"听听收藏"];

        }
            break;
        case 3:
        {
//            StoryPlayListViewController *playListVC = [[StoryPlayListViewController alloc]init];
//
//            //        playListVC.listModel = listModel;
//            playListVC.sourceType = StoryPlaySourceType_Recent;
            RecentPlayViewController * playListVC = [[RecentPlayViewController alloc]init];
            
            [APP_DELEGATE.navigationController pushViewController:playListVC animated:YES];
            
//            [MobClick event:EVENT_RECENTLY_PLAY_16];
            [[BaiduMobStat defaultStat] logEvent:@"e_myJump100" eventLabel:@"最近播放"];

        }
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
