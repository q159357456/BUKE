//
//  ListenerCollectCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ListenerCollectCell.h"
#import "XYDMPlaySoruceManage.h"
@interface ListenerCollectCell ()
@property(nonatomic,strong)XYDMCustomMusicPlayModel *model;
//@property (weak, nonatomic) IBOutlet UIImageView *pushImageView;
@property (weak, nonatomic) IBOutlet UIImageView *collectImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *playImgeView;

@end

@implementation ListenerCollectCell

+(instancetype)xibTableViewCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ListenerCollectCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push:)];
    self.collectImageView.userInteractionEnabled = YES;
    [self.collectImageView addGestureRecognizer:tap];
}

-(void) updateViewData:(CGSize ) size
{
    if(size.width > 375){
//        self.pushImageView.frame = CGRectMake(self.pushImageView.frame.origin.x + 40, self.pushImageView.frame.origin.y, self.pushImageView.frame.size.width, self.pushImageView.frame.size.height);
        self.collectImageView.frame = CGRectMake(self.collectImageView.frame.origin.x + 40, self.collectImageView.frame.origin.y, self.collectImageView.frame.size.width, self.collectImageView.frame.size.height);
        self.lineImageView.frame = CGRectMake(self.lineImageView.frame.origin.x, self.lineImageView.frame.origin.y, self.lineImageView.frame.size.width + 40, self.lineImageView.frame.size.height);
    }
}

-(void)loadData:(XYDMCustomMusicPlayModel *)model
{
//    [self.playButton setImage:[UIImage imageNamed:@"playList_icon_play"] forState:UIControlStateNormal];
//    [self.playButton setImage:[UIImage imageNamed:@"playList_icon_pause"]
    self.model = model;
    self.titleImg.text = model.musicName;
    self.durationLabel.text =  [[XYDMPlaySoruceManage singleton] TransformSecondToMinute:model.duration];
    if (model.isPlaying) {
        
        self.playImgeView.image = [UIImage imageNamed:@"playList_icon_pause"];
    }else
    {
        
         self.playImgeView.image = [UIImage imageNamed:@"playList_icon_play"];
    }
}

-(void)push:(UITapGestureRecognizer*)tap{
    
    if(4 == [APP_DELEGATE.snData.type integerValue]){
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:self.model.musicUrl];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PUSHMUSIC-BabyCare" object:[array mutableCopy]];
        
    }else{

        NSLog(@"推送");
        NSArray * urlList = @[[NSString stringWithFormat:@"%ld",(long)self.model.musicId]];
        [XYDMPlaySoruceManage pushMusic:urlList];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
