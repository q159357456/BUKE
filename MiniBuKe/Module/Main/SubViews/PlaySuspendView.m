//
//  PlaySuspendView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/8.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "PlaySuspendView.h"

@interface PlaySuspendView ()

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *seriesLabel;

@property (nonatomic,strong) UIButton *upButton;
@property (nonatomic,strong) UIButton *playButton;
@property (nonatomic,strong) UIButton *downButton;

@end

@implementation PlaySuspendView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return  self;
}

-(void)initView{
    [self setBackgroundColor: COLOR_STRING(@"#FFFFFF")];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, 2)];
    [lineImageView setBackgroundColor: COLOR_STRING(@"#F6F6F6")];
    [self addSubview:lineImageView];
    
    _iconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10, self.frame.size.height/2 - 47/2, 48, 47)];
    [_iconImageView setImage: [UIImage imageNamed:@"ic_play_image"]];
    [self addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.frame.origin.x + _iconImageView.frame.size.width + 5, 20, 119, 14)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text = @"马克与彩丽的故事";
    _nameLabel.font = MY_FONT(13);
    [self addSubview: _nameLabel];
    
    _seriesLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.frame.origin.x + _iconImageView.frame.size.width + 5, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 5, 119, 14)];
    _seriesLabel.textAlignment = NSTextAlignmentLeft;
    _seriesLabel.text = @"系列丛书";
    _seriesLabel.font = MY_FONT(11);
    _seriesLabel.textColor = COLOR_STRING(@"#909090");
    [self addSubview: _seriesLabel];
    
    _downButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 50, self.frame.size.height / 2 - 50/2, 50, 50)];
    //[_msgButton setBackgroundColor:[UIColor whiteColor]];
    [_downButton.titleLabel setFont:MY_FONT(18)];
    [_downButton setImage:[UIImage imageNamed:@"bt_down"] forState:UIControlStateNormal];
    [_downButton addTarget:self action:@selector(dowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //[_downButton setAdjustsImageWhenHighlighted:NO];
    [self addSubview:_downButton];
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(_downButton.frame.origin.x - 50, _downButton.frame.origin.y, 50, 50)];
    //[_msgButton setBackgroundColor:[UIColor whiteColor]];
    [_playButton.titleLabel setFont:MY_FONT(18)];
    [_playButton setImage:[UIImage imageNamed:@"bt_play"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //[_playButton setAdjustsImageWhenHighlighted:NO];
    [self addSubview:_playButton];
    
    _upButton = [[UIButton alloc] initWithFrame:CGRectMake(_playButton.frame.origin.x - 50, _playButton.frame.origin.y, 50, 50)];
    //[_msgButton setBackgroundColor:[UIColor whiteColor]];
    [_upButton.titleLabel setFont:MY_FONT(18)];
    [_upButton setImage:[UIImage imageNamed:@"bt_play_up"] forState:UIControlStateNormal];
    [_upButton addTarget:self action:@selector(upButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //[_upButton setAdjustsImageWhenHighlighted:NO];
    [self addSubview:_upButton];
    
    
    
    
}

-(IBAction)upButtonClick:(id)sender{
    NSLog(@"上一曲");
}

-(IBAction)playButtonClick:(id)sender{
    NSLog(@"播放");
}

-(IBAction)dowButtonClick:(id)sender{
    NSLog(@"下一曲");
}

@end
